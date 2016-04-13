import sys

for line in sys.stdin:
    if len(line.split('\t')) == 9 :
        line = line.replace(' .g', '.g') 
        attr = dict(item.strip().split(' ') for item in line.split('\t')[8].strip('\n').split(';') if len(item.split()) == 2)
        #attr3 = list(item.strip().split(' ') for item in line.split('\t')[8].strip('\n').split(';') if len(item.split()) > 2)
        #if len(attr3) > 0:
        #    print attr3
        gene_id = attr['gene_id'].strip('\"') if 'gene_id' in attr else "none"
        transcript_id = attr['transcript_id'].strip('\"') if 'transcript_id' in attr else "none"
        gene_name = attr['gene_name'].strip('\"') if 'gene_name' in attr else "none"
        oId = attr['oId'].strip('\"') if 'oId' in attr else "none"

        print gene_id + '\t' + transcript_id + '\t' + gene_name + '\t' + oId
