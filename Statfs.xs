#ifdef __cplusplus
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "config.h"

#if defined(_DARWIN__NOHEADER) || defined(_FREEBSD__NOHEADER) 
#include <sys/param.h>
#include <sys/mount.h>
#else
#include <sys/statfs.h>
#endif

#ifdef __cplusplus
}
#endif


typedef struct statfs Statfs;

MODULE = Filesys::Statfs	PACKAGE = Filesys::Statfs

void
statfs(dir)
	char *dir
	PREINIT:
	Statfs st;
	Statfs *st_ptr;
	PPCODE:
#ifdef _SOLARIS__
	if(statfs(dir, &st, 0, 0) == 0) {
#else
	if(statfs(dir, &st) == 0) {
#endif
		st_ptr = &st;
		EXTEND(sp, 15);
#ifdef _SOLARIS__
		PUSHs(sv_2mortal(newSViv(st_ptr->f_fstyp)));
#else
		PUSHs(sv_2mortal(newSViv(st_ptr->f_type)));
#endif
		PUSHs(sv_2mortal(newSVuv(st_ptr->f_bsize)));
		PUSHs(sv_2mortal(newSVuv(st_ptr->f_blocks)));
		PUSHs(sv_2mortal(newSVuv(st_ptr->f_bfree)));
		if(st_ptr->f_files < 0) {
			PUSHs(sv_2mortal(newSViv(st_ptr->f_files)));
			PUSHs(sv_2mortal(newSViv(st_ptr->f_ffree)));
		}
		else {
			PUSHs(sv_2mortal(newSVuv(st_ptr->f_files)));
			PUSHs(sv_2mortal(newSVuv(st_ptr->f_ffree)));
		}
#ifndef _SOLARIS__
		if(st_ptr->f_bavail < 0) {
			PUSHs(sv_2mortal(newSViv(st_ptr->f_bavail)));
		}
		else {
			PUSHs(sv_2mortal(newSVuv(st_ptr->f_bavail)));
		}
#endif
	}
