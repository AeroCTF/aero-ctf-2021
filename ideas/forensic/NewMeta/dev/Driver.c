/*++

Module Name:

    driver.c

Abstract:

    This file contains the driver entry points and callbacks.

Environment:

    Kernel-mode Driver Framework

--*/

#include "driver.h"
#include "driver.tmh"

#ifdef ALLOC_PRAGMA
#pragma alloc_text (INIT, DriverEntry)
#pragma alloc_text (PAGE, TestDriverEvtDeviceAdd)
#pragma alloc_text (PAGE, TestDriverEvtDriverContextCleanup)
#endif

NTSTATUS
DriverEntry(
    _In_ PDRIVER_OBJECT  DriverObject,
    _In_ PUNICODE_STRING RegistryPath
    )
/*++

Routine Description:
    DriverEntry initializes the driver and is the first routine called by the
    system after the driver is loaded. DriverEntry specifies the other entry
    points in the function driver, such as EvtDevice and DriverUnload.

Parameters Description:

    DriverObject - represents the instance of the function driver that is loaded
    into memory. DriverEntry must initialize members of DriverObject before it
    returns to the caller. DriverObject is allocated by the system before the
    driver is loaded, and it is released by the system after the system unloads
    the function driver from memory.

    RegistryPath - represents the driver specific path in the Registry.
    The function driver can use the path to store driver related data between
    reboots. The path does not store hardware instance specific data.

Return Value:

    STATUS_SUCCESS if successful,
    STATUS_UNSUCCESSFUL otherwise.

--*/
{

        // Aero{f7301b4efb72fc507c5a9a0053077de1}
        unsigned char result[38] = { 60, 123, 22, 63, 93, 115, 99, 6, 76, 113, 119, 9, 66, 13, 47, 65, 45, 120, 29, 29, 90, 69, 76, 26, 3, 13, 58, 22, 12, 35, 76, 79, 76, 85, 127, 76, 47, 81 };
        unsigned char keys[38];// = { 125, 30, 100, 80, 38, 21, 84, 53, 124, 64, 21, 61, 39, 107, 77, 118, 31, 30, 126, 40, 106, 114, 47, 47, 98, 52, 91, 38, 60, 22, 127, 127, 123, 98, 27, 41, 30, 44 };
        unsigned char output[38];

        keys[0] = 0;
        keys[1] = 1;
        keys[2] = 2;
        keys[3] = 3;
        keys[4] = 4;
        keys[5] = 5;
        keys[6] = 6;
        keys[7] = 7;
        keys[8] = 8;
        keys[9] = 9;
        keys[10] = 10;
        keys[11] = 11;
        keys[12] = 12;
        keys[13] = 13;
        keys[14] = 14;
        keys[15] = 15;
        keys[16] = 16;
        keys[17] = 17;
        keys[18] = 18;
        keys[19] = 19;
        keys[20] = 20;
        keys[21] = 21;
        keys[22] = 22;
        keys[23] = 23;
        keys[24] = 24;
        keys[25] = 25;
        keys[26] = 26;
        keys[27] = 27;
        keys[28] = 28;
        keys[29] = 29;
        keys[30] = 30;
        keys[31] = 31;
        keys[32] = 32;
        keys[33] = 33;
        keys[34] = 34;
        keys[35] = 35;
        keys[36] = 36;
        keys[37] = 37;
    
    WDF_DRIVER_CONFIG config;
    NTSTATUS status;
    WDF_OBJECT_ATTRIBUTES attributes;

    //
    // Initialize WPP Tracing
    //
    WPP_INIT_TRACING(DriverObject, RegistryPath);

    TraceEvents(TRACE_LEVEL_INFORMATION, TRACE_DRIVER, "%!FUNC! Entry");

    //
    // Register a cleanup callback so that we can call WPP_CLEANUP when
    // the framework driver object is deleted during driver unload.
    //

    for (int i = 0; i < 38; i++)
    {
        output[i] = (char)(keys[i] ^ result[i]);
    }

    WDF_OBJECT_ATTRIBUTES_INIT(&attributes);
    attributes.EvtCleanupCallback = TestDriverEvtDriverContextCleanup;

    WDF_DRIVER_CONFIG_INIT(&config,
                           TestDriverEvtDeviceAdd
                           );

    status = WdfDriverCreate(DriverObject,
                             RegistryPath,
                             &attributes,
                             &config,
                             WDF_NO_HANDLE
                             );

    if (!NT_SUCCESS(status)) {
        TraceEvents(TRACE_LEVEL_ERROR, TRACE_DRIVER, "WdfDriverCreate failed %!STATUS!", status);
        WPP_CLEANUP(DriverObject);
        return status;
    }

    TraceEvents(TRACE_LEVEL_INFORMATION, TRACE_DRIVER, "%!FUNC! Exit");
    return status;
}

NTSTATUS
TestDriverEvtDeviceAdd(
    _In_    WDFDRIVER       Driver,
    _Inout_ PWDFDEVICE_INIT DeviceInit
    )
/*++
Routine Description:

    EvtDeviceAdd is called by the framework in response to AddDevice
    call from the PnP manager. We create and initialize a device object to
    represent a new instance of the device.

Arguments:

    Driver - Handle to a framework driver object created in DriverEntry

    DeviceInit - Pointer to a framework-allocated WDFDEVICE_INIT structure.

Return Value:

    NTSTATUS

--*/
{
    NTSTATUS status;

    UNREFERENCED_PARAMETER(Driver);

    PAGED_CODE();

    TraceEvents(TRACE_LEVEL_INFORMATION, TRACE_DRIVER, "%!FUNC! Entry");

    status = TestDriverCreateDevice(DeviceInit);

    TraceEvents(TRACE_LEVEL_INFORMATION, TRACE_DRIVER, "%!FUNC! Exit");

    return status;
}

VOID
TestDriverEvtDriverContextCleanup(
    _In_ WDFOBJECT DriverObject
    )
/*++
Routine Description:

    Free all the resources allocated in DriverEntry.

Arguments:

    DriverObject - handle to a WDF Driver object.

Return Value:

    VOID.

--*/
{
    UNREFERENCED_PARAMETER(DriverObject);

    PAGED_CODE();

    TraceEvents(TRACE_LEVEL_INFORMATION, TRACE_DRIVER, "%!FUNC! Entry");

    //
    // Stop WPP Tracing
    //
    WPP_CLEANUP(WdfDriverWdmGetDriverObject((WDFDRIVER)DriverObject));
}
