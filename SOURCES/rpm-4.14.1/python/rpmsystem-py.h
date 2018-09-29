#ifndef H_SYSTEM_PYTHON
#define	H_SYSTEM_PYTHON

#if defined(__APPLE__)
#include <sys/types.h>
#endif

#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <structmember.h>

#if ((PY_MAJOR_VERSION << 8) | (PY_MINOR_VERSION << 0)) < 0x0205
typedef ssize_t Py_ssize_t;
typedef Py_ssize_t (*lenfunc)(PyObject *);
#endif  

/* Compatibility macros for Python < 2.6 */
#ifndef PyVarObject_HEAD_INIT
#define PyVarObject_HEAD_INIT(type, size) \
	PyObject_HEAD_INIT(type) size,
#endif 

#ifndef Py_TYPE
#define Py_TYPE(o) ((o)->ob_type)
#endif

#if ((PY_MAJOR_VERSION << 8) | (PY_MINOR_VERSION << 0)) < 0x0206
#define PyBytes_Check PyString_Check
#define PyBytes_FromString PyString_FromString
#define PyBytes_FromStringAndSize PyString_FromStringAndSize
#define PyBytes_Size PyString_Size
#define PyBytes_AsString PyString_AsString
#endif

#if ((PY_MAJOR_VERSION << 8) | (PY_MINOR_VERSION << 0)) >= 0x0207
#define CAPSULE_BUILD(ptr,name) PyCapsule_New(ptr, name, NULL)
#define CAPSULE_CHECK(obj) PyCapsule_CheckExact(obj)
#define CAPSULE_EXTRACT(obj,name) PyCapsule_GetPointer(obj, name)
#else
#define CAPSULE_BUILD(ptr,name) PyCObject_FromVoidPtr(ptr, NULL)
#define CAPSULE_CHECK(obj) PyCObject_Check(obj)
#define CAPSULE_EXTRACT(obj,name) PyCObject_AsVoidPtr(obj)
#endif

/* For Python 3, use the PyLong type throughout in place of PyInt */
#if PY_MAJOR_VERSION >= 3
#define PyInt_Check PyLong_Check
#define PyInt_AsLong PyLong_AsLong
#define PyInt_FromLong PyLong_FromLong
#define PyInt_AsUnsignedLongMask PyLong_AsUnsignedLongMask
#define PyInt_AsUnsignedLongLongMask PyLong_AsUnsignedLongLongMask
#define PyInt_AsSsize_t PyLong_AsSsize_t
#endif

#endif	/* H_SYSTEM_PYTHON */
