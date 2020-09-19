#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <stdint.h>

int main()
{
	int fd;
	uint64_t *ptr;
	unsigned page_size=sysconf(_SC_PAGESIZE);
	struct stat sb;

	/*
	 * this is fid 1, thermal mgt
	 * ex/ 
	 * # cat /sys/class/hwmon/hwmon3/temp1_input
	 * 39000
	 */
	fd = open("/dev/uio0", O_RDONLY|O_SYNC);
	if (fd < 0) {
		perror("uio open:");
		return errno;
	}

	ptr = (uint64_t *) mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
	if (!ptr) {
		perror("uio mmap:");
	} else {

		/* from dfl-fme-main.c :
		 * 
		 * #define FME_THERM_RDSENSOR_FMT1	0x10
		 * #define FPGA_TEMPERATURE	GENMASK_ULL(6, 0)
		 *
		 * case hwmon_temp_input:
		 * v = readq(feature->ioaddr + FME_THERM_RDSENSOR_FMT1);
		 * *val = (long)(FIELD_GET(FPGA_TEMPERATURE, v) * 1000);
		 * break;
		 */
		uint64_t v = ptr[2];
		v &= (1 << 6) -1;
		v *= 1000;
		printf("Temperature %d\n", v);
	    
		munmap(ptr, page_size);
	}
	if (close(fd))
		perror("uio close:");

	return errno;
}
