/*

Name: Saarth Deshpande
Roll Number: 23150
Batch: G9
Assignment No.: 5

*/

#include<stdio.h>
#include<conio.h>
#include<stdlib.h>
#include<dos.h>
#define SIZE 50

union REGS in,out;
struct SREGS s;

void createDirectory();
void deleteFile();
void copyFile();

int main()
{
	int resp;
	clrscr();
	do
	{
		printf("\nC Programming using DOS functions\n1. Create Directory\n2. Delete File\n3. Copy File\n4. Exit\nYour Choice: ");
		scanf("%d", &resp);
		switch(choice)
		{
			case 1: createDirectory();
							break;
			case 2: deleteFile();
							break;
			case 3: copyFile();
							break;
			case 4: return 1;
			default: printf("\nPlease enter a valid response.\n");
		}
	}while(resp != 4);
	getch();
	return 0;
}


void createDirectory()
{
	char dirname[50];
	flushall();
	printf("Directory Name: ");
	gets(dirname);

	in.x.dx = (int)&dirname;
	in.h.ah = 0x39;

	intdos(&in, &out);

	if(!out.x.cflag)
		printf("Directory Created Successfully!\n");
	else
		printf("Directory Could NOT be Created.\n");
}


void deleteFile()
{
	char filename[50];
	flushall();
	printf("\nFile to Delete: ");
	gets(filename);

	in.h.ah = 0x41;
	in.x.dx = FP_OFF(filename);

	intdos(&in, &out);

	if(!out.x.cflag)
		printf("\nFile Deleted Successfully!\n");
	else
		printf("\nError. File could not be deleted.\n");
}

void copyFile()
{
	char far(filename[20]), far(newfile[20]);
	int h1, h2, bytes;
	char far(buffer[512]);

	printf("\nFile to Copy: ");
	scanf("%s",filename);

	in.h.ah = 0x3D;		// open file in read mode
	in.x.dx = FP_OFF(filename);
	s.ds = FP_SEG(filename);
	in.h.al = 0x00;
	int86x(0x21, &in, &out, &s);
	h1 = out.x.ax;

	if(out.x.cflag)
		printf("\nError! File could not be read.\n");

	printf("\nNew File Name: ");
	scanf("%s",newfile);

	in.h.ah = 0x3C;
	in.x.dx = FP_OFF(newfile);
	in.x.cx = 0x00;
	int86(0x21, &in, &out);

	if(!out.x.cflag)
		printf("\nNew File Created!\n");

	in.h.ah = 0x3D;		// open file in write mode
	in.x.dx = FP_OFF(newfile);
	in.h.al = 0x01;
	int86(0x21, &in, &out);
	h2 = out.x.ax;


	in.h.ah = 0x3F;		// read file
	in.x.bx = h1;
	in.x.cx = 0xFF;
	in.x.dx = FP_OFF(buffer);
	s.ds = FP_SEG(buffer);
	int86x(0x21, &in, &out, &s);
	bytes = out.x.ax;

	if(!out.x.cflag)
		printf("\nReading %u bytes...\n",out.x.ax);

	in.h.ah = 0x40;		// write to file
	in.x.bx = h2;
	in.x.cx = bytes;
	in.x.dx = FP_OFF(buffer);
	s.ds = FP_SEG(buffer);
	int86x(0x21, &in, &out, &s);

	if(out.x.cflag)
		printf("\nError copying file!\n");
	else
	{
		printf("\nWriting %u bytes...\n",out.x.ax);
		printf("\nFile Copied Successfully!\n");
	}

	in.h.ah = 0x3E;		// close file
	in.x.dx = h1;
	int86(0x21, &in, &out);

	in.h.ah = 0x3E;		// close file
	in.x.dx = h2;
	int86(0x21, &in, &out);
}
