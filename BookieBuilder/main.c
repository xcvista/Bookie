//
//  main.c
//  BookieBuilder
//
//  Created by Maxthon Chan on 13-1-10.
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define isPrintable(c) ((c) < 0x33 || (c) > 0x7E)
#define MIN(x, y) (((x) > (y)) ? (y) : (x))

int main(int argc, const char * argv[])
{
    FILE *outputFile = stdout;
    FILE *inFile = stdin;
    int cont;
    
    char *buf = malloc(BUFSIZ);
    char *fileName = malloc(256);
    
    fprintf(stderr, "Hint: Press Ctrl-Z (Windows) or Ctrl-D (UNIX) to indicate an EOF.\n");
    
    do
    {
        
        cont = 0;
        fprintf(stderr, "Please input the output file's name, EOF for exit. [-]:");
        if (fgets(buf, BUFSIZ, inFile))
        {
            cont = 1;
            
            sscanf(buf, "%255s", fileName);
            if (strcmp(fileName, "-"))
            {
                outputFile = fopen(buf, "w+");
            }
            
            fprintf(stderr, "Generating property list prologue...\n");
            
            fprintf(outputFile, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                    "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
                    "<plist version=\"1.0\">\n"
                    "<dict>\n"
                    "<key>BKType</key>\n"
                    "<string>BKImageGalleryViewController</string>\n"
                    "<key>BKImages</key>\n"
                    "<array>\n");
            
            fprintf(stderr, "Please input the list of image files, one each line, EOF to end:\n");
            
            while (fgets(buf, BUFSIZ, inFile))
            {
                sscanf(buf, "%255s", fileName);
                fprintf(outputFile, "<string>%s</string>\n", fileName);
            }
            
            fprintf(stderr, "Generating property list epilogue...\n");
            
            fprintf(outputFile, "</array>\n"
                    "</dict>\n"
                    "</plist>\n");
            
            if (outputFile != stdout)
            {
                fclose(outputFile);
                outputFile = stdout;
            }
            
            
        }
    } while (cont);
    
    free(buf);
    free(fileName);
    
    putc('\n', stderr);
    fprintf(stderr, "Bye.");
    return 0;
}

