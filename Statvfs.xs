#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "config.h"
#include<sys/statvfs.h>
#ifdef __cplusplus
}
#endif

/* newSVuv isn't avail before 5.6 */
/* PERL_API_VERSION wasn't defined before 5.6 */

#define SIGNED_TEST(n) ((n * 0 - 1) < 0)

typedef struct statvfs Statvfs;

MODULE = Filesys::Statvfs	PACKAGE = Filesys::Statvfs

void
statvfs(dir)
	char *dir
	PREINIT:
	Statvfs st;
	PPCODE:
	if(statvfs(dir, &st) == 0) {
		EXTEND(sp, 15);
#ifdef PERL_API_VERSION 
		if(SIGNED_TEST(st.f_bsize))
			PUSHs(sv_2mortal(newSViv(st.f_bsize)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_bsize)));

		if(SIGNED_TEST(st.f_frsize))
			PUSHs(sv_2mortal(newSViv(st.f_frsize)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_frsize)));

		if(SIGNED_TEST(st.f_blocks))
			PUSHs(sv_2mortal(newSViv(st.f_blocks)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_blocks)));

		if(SIGNED_TEST(st.f_bfree))
			PUSHs(sv_2mortal(newSViv(st.f_bfree)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_bfree)));

		if(SIGNED_TEST(st.f_bavail))
			PUSHs(sv_2mortal(newSViv(st.f_bavail)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_bavail)));

		if(SIGNED_TEST(st.f_files))
			PUSHs(sv_2mortal(newSViv(st.f_files)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_files)));

		if(SIGNED_TEST(st.f_ffree))
			PUSHs(sv_2mortal(newSViv(st.f_ffree)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_ffree)));

		if(SIGNED_TEST(st.f_favail))
			PUSHs(sv_2mortal(newSViv(st.f_favail)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_favail)));
#else 
		PUSHs(sv_2mortal(newSViv(st.f_bsize)));
                PUSHs(sv_2mortal(newSViv(st.f_frsize)));
                PUSHs(sv_2mortal(newSViv(st.f_blocks)));
                PUSHs(sv_2mortal(newSViv(st.f_bfree)));
                PUSHs(sv_2mortal(newSViv(st.f_bavail)));
                PUSHs(sv_2mortal(newSViv(st.f_files)));
                PUSHs(sv_2mortal(newSViv(st.f_ffree)));
                PUSHs(sv_2mortal(newSViv(st.f_favail)));
#endif 
#if defined(_AIX__) || defined(_LINUX__)
		PUSHs(sv_2mortal(newSViv(0)));
#elif PERL_API_VERSION
		if(SIGNED_TEST(st.f_fsid))
			PUSHs(sv_2mortal(newSViv(st.f_fsid)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_fsid)));
#else
		PUSHs(sv_2mortal(newSViv(st.f_fsid)));
#endif
#ifdef _LINUX__
		PUSHs(sv_2mortal(newSVpv(NULL, 1)));
#else
		PUSHs(sv_2mortal(newSVpv(st.f_basetype, 0)));
#endif
#ifdef PERL_API_VERSION
		if(SIGNED_TEST(st.f_flag))
			PUSHs(sv_2mortal(newSViv(st.f_flag)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_flag)));

		if(SIGNED_TEST(st.f_namemax))
			PUSHs(sv_2mortal(newSViv(st.f_namemax)));
		else
			PUSHs(sv_2mortal(newSVuv(st.f_namemax)));
#else
			PUSHs(sv_2mortal(newSViv(st.f_flag)));
			PUSHs(sv_2mortal(newSViv(st.f_namemax)));
#endif
#if defined(_DEC__) || defined(_LINUX__)
		PUSHs(sv_2mortal(newSVpv(NULL, 1)));
#else
		PUSHs(sv_2mortal(newSVpv(st.f_fstr, 0)));
#endif
	}
