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

#define SIGNED_TEST(n) ((n * 0 - 1) < 0)


typedef struct statfs Statfs;

MODULE = Filesys::Statfs	PACKAGE = Filesys::Statfs

void
statfs(dir)
	char *dir
	PREINIT:
	Statfs st;
	PPCODE:
#ifdef _SOLARIS__
	if(statfs(dir, &st, 0, 0) == 0) {
#else
	if(statfs(dir, &st) == 0) {
#endif
		EXTEND(sp, 15);
#ifdef _SOLARIS__
		if(SIGNED_TEST(st.f_fstyp))
			PUSHs(sv_2mortal(newSViv(st.f_fstyp)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_fstyp)));
#else
		if(SIGNED_TEST(st.f_type))
			PUSHs(sv_2mortal(newSViv(st.f_type)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_type)));
#endif
		if(SIGNED_TEST(st.f_bsize))
			PUSHs(sv_2mortal(newSViv(st.f_bsize)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_bsize)));

		if(SIGNED_TEST(st.f_blocks))
			PUSHs(sv_2mortal(newSViv(st.f_blocks)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_blocks)));

		if(SIGNED_TEST(st.f_bfree))
			PUSHs(sv_2mortal(newSViv(st.f_bfree)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_bfree)));

		if(SIGNED_TEST(st.f_files))
			PUSHs(sv_2mortal(newSViv(st.f_files)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_files)));

		if(SIGNED_TEST(st.f_ffree))
			PUSHs(sv_2mortal(newSViv(st.f_ffree)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_ffree)));
#ifndef _SOLARIS__
		if(SIGNED_TEST(st.f_bavail))
			PUSHs(sv_2mortal(newSViv(st.f_bavail)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_bavail)));
#endif
	}
