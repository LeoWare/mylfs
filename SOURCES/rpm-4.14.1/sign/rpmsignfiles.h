#ifndef H_RPMSIGNFILES
#define H_RPMSIGNFILES

#include <rpm/rpmtypes.h>
#include <rpm/rpmutil.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Sign file digests in header and store the signatures in header
 * @param h		package header
 * @param key		signing key
 * @param keypass	signing key password
 * @return		RPMRC_OK on success
 */
RPM_GNUC_INTERNAL
rpmRC rpmSignFiles(Header h, const char *key, char *keypass);

#ifdef _cplusplus
}
#endif

#endif /* H_RPMSIGNFILES */
