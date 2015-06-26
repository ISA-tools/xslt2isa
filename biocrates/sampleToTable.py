__author__ = 'alfie'

import sys, os
from bs4 import BeautifulSoup as Soup


def generatePolarityAttrsDict(plate, polarity, myAttrs, rawDataFileName, mydict):
    injection = plate.find_all('injection', {'polarity': polarity})
    if (len(injection) > 0):
        for pi in injection:
            rawDataFileName.append(pi.get('rawdatafilename'))
            for p in pi.find_all('measure'):
                myrdfname = p.find_parent('injection').get('rawdatafilename').split('.')[0]
                usedop = p.find_parent('plate').get('usedop')
                platebarcode = p.find_parent('plate').get('platebarcode')
                for attr, value in p.attrs.iteritems():
                    if attr != 'metabolite':
                        mydict[p.get('metabolite') + '-' + myrdfname + '-' + attr + '-' + polarity.lower() + '-' + usedop + '-' + platebarcode] = value
                        myAttrs.append(attr)
    return (myAttrs, rawDataFileName, mydict)


def generateAttrsDict(plates):
    posAttrs = []
    negAttrs = []
    posRawDataFileName = []
    negRawDataFileName = []
    mydict = {}

    for plate in plates:
        posAttrs, posRawDataFileName, mydict = generatePolarityAttrsDict(plate, 'POSITIVE', posAttrs, posRawDataFileName, mydict)
        negAttrs, negRawDataFileName, mydict = generatePolarityAttrsDict(plate, 'NEGATIVE', posAttrs, posRawDataFileName, mydict)
    return (posAttrs, negAttrs, posRawDataFileName, negRawDataFileName, mydict)


def writeOutToFile(plate, polarity, usedop, platebarcode, output_dir, rawDataFileName, uniqueAttrs, uniqueMetaboliteIdentifiers, mydict):
    pos_injection = plate.find_all('injection', {'polarity': polarity})
    if (len(pos_injection) > 0):
        filename = usedop + '-' + platebarcode + '-' + polarity.lower() + '-maf.txt'
        print (filename)
        with open(os.path.join(output_dir, filename), 'w') as file_handler:
            # writing out the header
            file_handler.write('Sample ID')
            for rawdatafname in rawDataFileName:
                for myattr in uniqueAttrs:
                    file_handler.write('\t' + rawdatafname.split('.')[0] + '[' + myattr + ']')
            # now the rest of the rows
            for mymetabolite in uniqueMetaboliteIdentifiers:
                file_handler.write('\n' + mymetabolite)
                for rawdatafname in rawDataFileName:
                    for myattr in uniqueAttrs:
                        mykey = mymetabolite + '-' + rawdatafname.split('.')[0] + '-' + myattr + '-' + polarity.lower() + '-' + usedop + '-' + platebarcode
                        if mykey in mydict:
                            file_handler.write('\t' + mydict[mykey])
                        else:
                            file_handler.write('\t')
        file_handler.close()


def parseSample(file):
    folder_name = 'output'
    output_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), folder_name)

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    file = sys.argv[1]
    handler = open(file).read()
    soup = Soup(handler)

    # extracting the unique metabolite identifiers
    metaboliteList = []
    metabolite = soup.find_all('metabolite')
    for met in metabolite:
        metaboliteList.append(met.get('identifier'))
    uniqueMetaboliteIdentifiers = list(set(metaboliteList))

    # extracting the distinct column labels and the rawdatafilename
    plates = soup.find_all('plate')
    posAttrs, negAttrs, posRawDataFileName, negRawDataFileName, mydict = generateAttrsDict(plates)
    uniquePosAttrs = list(set(posAttrs))
    uniqueNegAttrs = list(set(negAttrs))

    # creating the sample tab files
    for plate in plates:
        usedop = plate.get('usedop')
        platebarcode = plate.get('platebarcode')
        writeOutToFile(plate, 'POSITIVE', usedop, platebarcode, output_dir, posRawDataFileName, uniquePosAttrs, uniqueMetaboliteIdentifiers, mydict)
        writeOutToFile(plate, 'NEGATIVE', usedop, platebarcode, output_dir, negRawDataFileName, uniqueNegAttrs, uniqueMetaboliteIdentifiers, mydict)


if __name__ == "__main__":
    parseSample(sys.argv[1])