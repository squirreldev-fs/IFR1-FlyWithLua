IFR1_MODE = 0
IFR1_LAST_MODE = 0

IFR1_LED_AP = false
IFR1_LED_HDG = false
IFR1_LED_NAV = false
IFR1_LED_APR = false
IFR1_LED_ALT = false
IFR1_LED_VS = false

IFR1_LAST_BTN_KNOB = false
IFR1_LAST_BTN_SWAP = false
IFR1_LAST_BTN_AP = false
IFR1_LAST_BTN_HDG = false
IFR1_LAST_BTN_NAV = false
IFR1_LAST_BTN_APR = false
IFR1_LAST_BTN_ALT = false
IFR1_LAST_BTN_VS = false
IFR1_LAST_BTN_DCT = false
IFR1_LAST_BTN_MNU = false
IFR1_LAST_BTN_CLR = false
IFR1_LAST_BTN_ENT = false

IFR1_BOTH_BTN_ALT_VS = false

IFR1_BTN_KNOB = false
IFR1_BTN_SWAP = false
IFR1_BTN_AP = false
IFR1_BTN_HDG = false
IFR1_BTN_NAV = false
IFR1_BTN_APR = false
IFR1_BTN_ALT = false
IFR1_BTN_VS = false
IFR1_BTN_DCT = false
IFR1_BTN_MNU = false
IFR1_BTN_CLR = false
IFR1_BTN_ENT = false

IFR1_MODE_SHIFT = false

IFR1_MODE_VALUE_COM1 = 0
IFR1_MODE_VALUE_COM2 = 1
IFR1_MODE_VALUE_NAV1 = 2
IFR1_MODE_VALUE_NAV2 = 3
IFR1_MODE_VALUE_FMS1 = 4
IFR1_MODE_VALUE_FMS2 = 5
IFR1_MODE_VALUE_AP   = 6
IFR1_MODE_VALUE_XPDR = 7

IFR1_LED_LAST_WRITE = 0xff

IFR1_OPEN_TIME = 0.0

IFR1_DEVICE = nil
IFR1_DEVICE_VID = 0x4d8
IFR1_DEVICE_PID = 0xe6d6
IFR1_LAST_NUMBER_OF_HID_DEVICES = 0
IFR1_FOUND = false

DataRef("heading", "sim/cockpit/autopilot/heading_mag", "writable")
DataRef("nav1_obs", "sim/cockpit/radios/nav1_obs_degm", "writable")
DataRef("nav2_obs", "sim/cockpit/radios/nav2_obs_degm2", "writable")
DataRef("xpdr_mode", "sim/cockpit2/radios/actuators/transponder_mode", "writable")
DataRef("xpdr_ident", "sim/cockpit2/radios/indicators/transponder_id")
DataRef("ap_on", "sim/cockpit2/autopilot/servos_on")
DataRef("ap_lateral", "sim/cockpit2/autopilot/heading_mode")
DataRef("ap_vertical", "sim/cockpit2/autopilot/altitude_mode")
DataRef("ap_appr", "sim/cockpit2/autopilot/approach_status")
DataRef("ap_vs", "sim/cockpit2/autopilot/vvi_dial_fpm", "writable")
DataRef("ap_alt", "sim/cockpit2/autopilot/altitude_dial_ft", "writable")
DataRef("ap_state", "sim/cockpit/autopilot/autopilot_state")
DataRef("sim_time", "sim/network/misc/network_time_sec")
DataRef("ap_alt_hold", "sim/cockpit2/autopilot/altitude_hold_status")

AW109_RESET_NEEDED = false
AW109_PUSH_TIMER = 0
AW109_IAS_HOT = false
AW109_HDG_HOT = false
AW109_ALT_HOT = false
AW109_VS_HOT = false
AW109_TIME_LAST_ACTION = 0

function ifr1_close()
    if IFR1_DEVICE ~= nil then
        hid_write(IFR1_DEVICE, 11, 0) -- Switch off LEDs
        hid_close(IFR1_DEVICE)
        IFR1_DEVICE = nil
    end
    IFR1_MODE = 0
    IFR1_BTN_KNOB = false
    IFR1_BTN_SWAP = false
    IFR1_BTN_AP =   false
    IFR1_BTN_HDG =  false
    IFR1_BTN_NAV =  false
    IFR1_BTN_APR =  false
    IFR1_BTN_ALT =  false
    IFR1_BTN_VS =   false
    IFR1_BTN_DCT =  false
    IFR1_BTN_MNU =  false
    IFR1_BTN_CLR =  false
    IFR1_BTN_ENT =  false
    IFR1_LAST_MODE = 0
    IFR1_LAST_BTN_KNOB = false
    IFR1_LAST_BTN_SWAP = false
    IFR1_LAST_BTN_AP =   false
    IFR1_LAST_BTN_HDG =  false
    IFR1_LAST_BTN_NAV =  false
    IFR1_LAST_BTN_APR =  false
    IFR1_LAST_BTN_ALT =  false
    IFR1_LAST_BTN_VS =   false
    IFR1_LAST_BTN_DCT =  false
    IFR1_LAST_BTN_MNU =  false
    IFR1_LAST_BTN_CLR =  false
    IFR1_LAST_BTN_ENT =  false
end

function ifr1_open()
    local connected = IFR1_DEVICE ~= nil

    if NUMBER_OF_HID_DEVICES ~= IFR1_LAST_NUMBER_OF_HID_DEVICES then
        IFR1_LAST_NUMBER_OF_HID_DEVICES = NUMBER_OF_HID_DEVICES
        IFR1_FOUND = false
        ALL_HID_DEVICES, NUMBER_OF_HID_DEVICES = create_HID_table()
        for i = 1, NUMBER_OF_HID_DEVICES do
            if ALL_HID_DEVICES[i].vendor_id == IFR1_DEVICE_VID and ALL_HID_DEVICES[i].product_id == IFR1_DEVICE_PID then
                IFR1_FOUND = true
                break
            end
        end
    end

    if connected and not IFR1_FOUND then
        ifr1_close()
        return -- re-open on next loop to ensure init correctly
    end

    if IFR1_FOUND and not connected then
        IFR1_DEVICE = hid_open(IFR1_DEVICE_VID,IFR1_DEVICE_PID)
        if IFR1_DEVICE ~= nil then
            hid_set_nonblocking(IFR1_DEVICE, 1)
            hid_write(IFR1_DEVICE, 11, IFR1_LED_LAST_WRITE)
        end
    end
end

function ifr1_acquire_buttons(b0, b1, b2, mv)
    IFR1_LAST_BTN_KNOB = IFR1_BTN_KNOB
    IFR1_LAST_BTN_SWAP = IFR1_BTN_SWAP
    IFR1_LAST_BTN_AP = IFR1_BTN_AP
    IFR1_LAST_BTN_HDG = IFR1_BTN_HDG
    IFR1_LAST_BTN_NAV = IFR1_BTN_NAV
    IFR1_LAST_BTN_APR = IFR1_BTN_APR
    IFR1_LAST_BTN_ALT = IFR1_BTN_ALT
    IFR1_LAST_BTN_VS = IFR1_BTN_VS
    IFR1_LAST_BTN_DCT = IFR1_BTN_DCT
    IFR1_LAST_BTN_MNU = IFR1_BTN_MNU
    IFR1_LAST_BTN_CLR = IFR1_BTN_CLR
    IFR1_LAST_BTN_ENT = IFR1_BTN_ENT
    IFR1_LAST_MODE = IFR1_MODE

    IFR1_MODE = mv
    IFR1_BTN_KNOB = bit.band(b1, 0x02) > 0
    IFR1_BTN_SWAP = bit.band(b1, 0x01) > 0
    IFR1_BTN_AP =   bit.band(b1, 0x40) > 0
    IFR1_BTN_HDG =  bit.band(b1, 0x80) > 0
    IFR1_BTN_NAV =  bit.band(b2, 0x01) > 0
    IFR1_BTN_APR =  bit.band(b2, 0x02) > 0
    IFR1_BTN_ALT =  bit.band(b2, 0x04) > 0
    IFR1_BTN_VS =   bit.band(b2, 0x08) > 0
    IFR1_BTN_DCT =  bit.band(b0, 0x10) > 0
    IFR1_BTN_MNU =  bit.band(b0, 0x20) > 0
    IFR1_BTN_CLR =  bit.band(b0, 0x40) > 0
    IFR1_BTN_ENT =  bit.band(b0, 0x80) > 0
end

function ifr1_handle_com_freq(k0, k1, com_nb)
    for i = 1, math.abs(k0) do
        if k0 < 0 then
            command_once(string.format("sim/radios/stby_com%d_coarse_down_833", com_nb))
        else
            command_once(string.format("sim/radios/stby_com%d_coarse_up_833", com_nb))
        end
    end
    for i = 1, math.abs(k1) do
        if k1 < 0 then
            command_once(string.format("sim/radios/stby_com%d_fine_down_833", com_nb))
        else
            command_once(string.format("sim/radios/stby_com%d_fine_up_833", com_nb))
        end
    end
    if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
        command_once(string.format("sim/radios/com%d_standy_flip", com_nb))
    end
end

function ifr1_handle_nav_freq(k0, k1, com_nb)
    for i = 1, math.abs(k0) do
        if k0 < 0 then
            command_once(string.format("sim/radios/stby_nav%d_coarse_down", com_nb))
        else
            command_once(string.format("sim/radios/stby_nav%d_coarse_up", com_nb))
        end
    end
    for i = 1, math.abs(k1) do
        if k1 < 0 then
            command_once(string.format("sim/radios/stby_nav%d_fine_down", com_nb))
        else
            command_once(string.format("sim/radios/stby_nav%d_fine_up", com_nb))
        end
    end
    if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
        command_once(string.format("sim/radios/nav%d_standy_flip", com_nb))
    end
end

function ifr1_process_buttons_knobs_standard(k0, k1)
    if (IFR1_MODE <= IFR1_MODE_VALUE_NAV2 or IFR1_MODE == IFR1_MODE_VALUE_XPDR) and IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
        IFR1_MODE_SHIFT = not IFR1_MODE_SHIFT
    end

    if IFR1_MODE ~= IFR1_LAST_MODE then
        IFR1_MODE_SHIFT = false
    end

    local sum_knob = k0 + k1

    if IFR1_MODE_SHIFT then
        if IFR1_MODE == IFR1_MODE_VALUE_COM1 then
            if IFR1_BTN_HDG and not IFR1_LAST_BTN_HDG then
                command_once("sim/instruments/DG_sync_mag")
            end
            heading = (heading + k0 * 10 + k1) % 360
        end

        if IFR1_MODE == IFR1_MODE_VALUE_COM2 then
            for i = 1, math.abs(sum_knob) do
                if sum_knob < 0 then
                    command_once("sim/instruments/barometer_down")
                else
                    command_once("sim/instruments/barometer_up")
                end
            end
            if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                command_once("sim/instruments/barometer_std")
            end
        end

        if IFR1_MODE == IFR1_MODE_VALUE_NAV1 then
            nav1_obs = (nav1_obs + k0 * 10 + k1) % 360
        end

        if IFR1_MODE == IFR1_MODE_VALUE_NAV2 then
            nav2_obs = (nav2_obs + k0 * 10 + k1) % 360
        end

        if IFR1_MODE == IFR1_MODE_VALUE_XPDR then
            xpdr_mode = math.max(0, math.min(7, xpdr_mode + sum_knob))
        end
    else -- normal (not shift) mode
        if IFR1_MODE == IFR1_MODE_VALUE_COM1 then
            ifr1_handle_com_freq(k0, k1, 1)
        end

        if IFR1_MODE == IFR1_MODE_VALUE_COM2 then
            ifr1_handle_com_freq(k0, k1, 2)
        end

        if IFR1_MODE == IFR1_MODE_VALUE_NAV1 then
            ifr1_handle_nav_freq(k0, k1, 1)
        end

        if IFR1_MODE == IFR1_MODE_VALUE_NAV2 then
            ifr1_handle_nav_freq(k0, k1, 2)
        end

        if IFR1_MODE == IFR1_MODE_VALUE_FMS1 or IFR1_MODE == IFR1_MODE_VALUE_FMS2 then
            local fms_no = IFR1_MODE == IFR1_MODE_VALUE_FMS1 and 1 or 2

            if IFR1_BTN_DCT and not IFR1_LAST_BTN_DCT then
                command_once(string.format("sim/GPS/g430n%d_direct", fms_no))
            end

            if IFR1_BTN_MNU and not IFR1_LAST_BTN_MNU then
                command_once(string.format("sim/GPS/g430n%d_menu", fms_no))
            end

            if IFR1_BTN_CLR and not IFR1_LAST_BTN_CLR then
                command_begin(string.format("sim/GPS/g430n%d_clr", fms_no))
            elseif not IFR1_BTN_CLR and IFR1_LAST_BTN_CLR then
                command_end(string.format("sim/GPS/g430n%d_clr", fms_no))
            end

            if IFR1_BTN_ENT and not IFR1_LAST_BTN_ENT then
                command_once(string.format("sim/GPS/g430n%d_ent", fms_no))
            end

            if IFR1_BTN_AP and not IFR1_LAST_BTN_AP then
                command_once(string.format("sim/GPS/g430n%d_cdi", fms_no))
            end

            if IFR1_BTN_HDG and not IFR1_LAST_BTN_HDG then
                command_once(string.format("sim/GPS/g430n%d_obs", fms_no))
            end

            if IFR1_BTN_NAV and not IFR1_LAST_BTN_NAV then
                command_once(string.format("sim/GPS/g430n%d_msg", fms_no))
            end

            if IFR1_BTN_APR and not IFR1_LAST_BTN_APR then
                command_once(string.format("sim/GPS/g430n%d_fpl", fms_no))
            end

            if IFR1_BTN_ALT and not IFR1_LAST_BTN_ALT then
                command_once(string.format("sim/GPS/g430n%d_vnav", fms_no))
            end

            if IFR1_BTN_VS and not IFR1_LAST_BTN_VS then
                command_once(string.format("sim/GPS/g430n%d_proc", fms_no))
            end

            if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
                command_once(string.format("sim/GPS/g430n%d_cursor", fms_no))
            end

            for i = 1, math.abs(k1) do
                if k1 < 0 then
                    command_once(string.format("sim/GPS/g430n%d_page_dn", fms_no))
                else
                    command_once(string.format("sim/GPS/g430n%d_page_up", fms_no))
                end
            end

            for i = 1, math.abs(k0) do
                if k0 < 0 then
                    command_once(string.format("sim/GPS/g430n%d_chapter_dn", fms_no))
                else
                    command_once(string.format("sim/GPS/g430n%d_chapter_up", fms_no))
                end
            end
            
        end

        if IFR1_MODE == IFR1_MODE_VALUE_AP then
            local last_ap_vs = ap_vs
            local last_ap_alt = ap_alt
            ap_vs = ap_vs + k0 * 100
            ap_alt = ap_alt + k1 * 100

            if IFR1_BTN_AP and not IFR1_LAST_BTN_AP then
                command_once("sim/autopilot/servos_toggle")
            end

            if IFR1_BTN_HDG and not IFR1_LAST_BTN_HDG then
                command_once("sim/autopilot/heading")
            end

            if IFR1_BTN_NAV and not IFR1_LAST_BTN_NAV then
                command_once("sim/autopilot/NAV")
            end

            if IFR1_BTN_APR and not IFR1_LAST_BTN_APR then
                command_once("sim/autopilot/approach")
            end

            if IFR1_BTN_ALT and IFR1_BTN_VS and not (IFR1_LAST_BTN_ALT and IFR1_LAST_BTN_VS) then
                IFR1_BOTH_BTN_ALT_VS = true
                command_once("sim/autopilot/alt_vs")
            end
            if not IFR1_BTN_ALT and not IFR1_BTN_VS then
                IFR1_BOTH_BTN_ALT_VS = false
            end

            if IFR1_LAST_BTN_ALT and not IFR1_BTN_ALT and not IFR1_BOTH_BTN_ALT_VS then
                command_once("sim/autopilot/altitude_hold")
            end

            if IFR1_LAST_BTN_VS and not IFR1_BTN_VS and not IFR1_BOTH_BTN_ALT_VS then
                command_once("sim/autopilot/vertical_speed")
            end
        end

        if IFR1_MODE == IFR1_MODE_VALUE_XPDR then
            if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                set("sim/cockpit2/radios/actuators/transponder_code", 7000)
            end
    
            for i = 1, math.abs(k1) do
                if k1 < 0 then
                    command_once("sim/transponder/transponder_34_down")
                else
                    command_once("sim/transponder/transponder_34_up")
                end
            end

            for i = 1, math.abs(k0) do
                if k0 < 0 then
                    command_once("sim/transponder/transponder_12_down")
                else
                    command_once("sim/transponder/transponder_12_up")
                end
            end
    
            if IFR1_BTN_AP and not IFR1_LAST_BTN_AP then
                command_once("sim/transponder/transponder_ident")
            end
        end
    end
end

function ifr1_process_buttons_knobs_aw109sp(k0, k1)
    if IFR1_MODE ~= IFR1_LAST_MODE then
        IFR1_MODE_SHIFT = false
        AW109_IAS_HOT = false
        AW109_HDG_HOT = false
        AW109_ALT_HOT = false
        AW109_VS_HOT = false
    end

    local sum_knob = k0 + k1

    if IFR1_MODE == IFR1_MODE_VALUE_COM1 then
        ifr1_handle_com_freq(k0, k1, 1)
    end

    if IFR1_MODE == IFR1_MODE_VALUE_COM2 then
        if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
            IFR1_MODE_SHIFT = not IFR1_MODE_SHIFT
        end

        if IFR1_MODE_SHIFT then
            if IFR1_LAST_BTN_SWAP and not IFR1_BTN_SWAP then
                set("aw109/cockpit/button/standby/knob_press", 1)
                set("aw109/cockpit/button/standby/knob_press", 0)
            end

            set("aw109/cockpit/knob/standby/knob", get("aw109/cockpit/knob/standby/knob") + k1 + 10 * k0)
        else
            ifr1_handle_com_freq(k0, k1, 2)
        end
    end

    if IFR1_MODE == IFR1_MODE_VALUE_NAV1 then
        if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
            IFR1_MODE_SHIFT = not IFR1_MODE_SHIFT
        end

        if IFR1_MODE_SHIFT then
            for i = 1, math.abs(k1) do
                if k1 < 0 then
                    command_once("sim/radios/actv_adf1_ones_tens_down")
                else
                    command_once("sim/radios/actv_adf1_ones_tens_up")
                end
            end

            for i = 1, math.abs(k0) do
                if k0 < 0 then
                    command_once("sim/radios/actv_adf1_hundreds_thous_down")
                else
                    command_once("sim/radios/actv_adf1_hundreds_thous_up")
                end
            end
        else
            ifr1_handle_nav_freq(k0, k1, 1)
        end
    end

    if IFR1_MODE == IFR1_MODE_VALUE_NAV2 then
        ifr1_handle_nav_freq(k0, k1, 2)
    end

    if IFR1_MODE == IFR1_MODE_VALUE_FMS1 or IFR1_MODE == IFR1_MODE_VALUE_FMS2 then
        local efis = IFR1_MODE == IFR1_MODE_VALUE_FMS1 and 2 or 3

        if IFR1_BTN_DCT and not IFR1_LAST_BTN_DCT then
            command_once(string.format("aw109/button/EFIS_%d_R1", efis))
        end

        if IFR1_BTN_MNU and not IFR1_LAST_BTN_MNU then
            command_once(string.format("aw109/button/EFIS_%d_R2", efis))
        end

        if IFR1_BTN_CLR and not IFR1_LAST_BTN_CLR then
            command_once(string.format("aw109/button/EFIS_%d_R3", efis))
        end

        if IFR1_BTN_ENT and not IFR1_LAST_BTN_ENT then
            command_once(string.format("aw109/button/EFIS_%d_R4", efis))
        end

        if IFR1_BTN_AP and not IFR1_LAST_BTN_AP then
            command_once(string.format("aw109/button/EFIS_%d_L1", efis))
        end

        if IFR1_BTN_HDG and not IFR1_LAST_BTN_HDG then
            command_once(string.format("aw109/button/EFIS_%d_L2", efis))
        end

        if IFR1_BTN_NAV and not IFR1_LAST_BTN_NAV then
            command_once(string.format("aw109/button/EFIS_%d_L3", efis))
        end

        if IFR1_BTN_APR and not IFR1_LAST_BTN_APR then
            command_once(string.format("aw109/button/EFIS_%d_L4", efis))
        end

        if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
            command_once(string.format("aw109/button/EFIS_%d_ENT", efis))
        end

        if k1 < 0 then
            command_once(string.format("aw109/button/EFIS_%d_ROT_DEC", efis))
        elseif k1 > 0 then
            command_once(string.format("aw109/button/EFIS_%d_ROT_INC", efis))
        end

        if k0 < 0 then
            command_once(string.format("aw109/button/EFIS_%d_BRT_ROT_DEC", efis))
        elseif k0 > 0 then
            command_once(string.format("aw109/button/EFIS_%d_BRT_ROT_INC", efis))
        end
    end

    if IFR1_MODE == IFR1_MODE_VALUE_AP then
        if IFR1_BTN_AP and not IFR1_LAST_BTN_AP then
            AW109_PUSH_TIMER = sim_time
        elseif IFR1_LAST_BTN_AP and not IFR1_BTN_AP then
            if sim_time - AW109_PUSH_TIMER >= 0.5 then
                set("aw109/cockpit/button/apms/ias_push", 1)
                set("aw109/cockpit/button/apms/ias_push", 0)
            end
            AW109_IAS_HOT = not AW109_IAS_HOT
            AW109_HDG_HOT = false
            AW109_ALT_HOT = false
            AW109_VS_HOT = false
        end

        if IFR1_BTN_HDG and not IFR1_LAST_BTN_HDG then
            AW109_PUSH_TIMER = sim_time
        elseif IFR1_LAST_BTN_HDG and not IFR1_BTN_HDG then
            if sim_time - AW109_PUSH_TIMER >= 0.5 then
                command_once("sim/autopilot/heading_sync")
            end
            AW109_IAS_HOT = false
            AW109_HDG_HOT = not AW109_HDG_HOT
            AW109_ALT_HOT = false
            AW109_VS_HOT = false
        end

        if IFR1_BTN_NAV and not IFR1_LAST_BTN_NAV then
            command_once("sim/autopilot/NAV")
        end

        if IFR1_BTN_APR and not IFR1_LAST_BTN_APR then
            AW109_PUSH_TIMER = sim_time
        elseif IFR1_LAST_BTN_APR and not IFR1_BTN_APR then
            if sim_time - AW109_PUSH_TIMER >= 0.5 then
                set("aw109/cockpit/button/apms/gs", 1)
                set("aw109/cockpit/button/apms/gs", 0)
            else
                command_once("sim/autopilot/approach")
            end
        end

        if IFR1_BTN_ALT and not IFR1_LAST_BTN_ALT then
            AW109_PUSH_TIMER = sim_time
        end
        if IFR1_BTN_ALT and IFR1_BTN_VS and not (IFR1_LAST_BTN_ALT and IFR1_LAST_BTN_VS) then
            IFR1_BOTH_BTN_ALT_VS = true
            command_once("sim/autopilot/level_change")
        end

        if IFR1_LAST_BTN_ALT and not IFR1_BTN_ALT and not IFR1_BOTH_BTN_ALT_VS then
            if sim_time - AW109_PUSH_TIMER >= 0.5 then
                command_once("sim/autopilot/altitude_hold")
            end
            AW109_IAS_HOT = false
            AW109_HDG_HOT = false
            AW109_ALT_HOT = not AW109_ALT_HOT
            AW109_VS_HOT = false
        end

        if IFR1_BTN_VS and not IFR1_LAST_BTN_VS then
            AW109_PUSH_TIMER = sim_time
        elseif IFR1_LAST_BTN_VS and not IFR1_BTN_VS and not IFR1_BOTH_BTN_ALT_VS then
            if sim_time - AW109_PUSH_TIMER >= 0.5 then
                command_once("sim/autopilot/vertical_speed")
            end
            AW109_IAS_HOT = false
            AW109_HDG_HOT = false
            AW109_ALT_HOT = false
            AW109_VS_HOT = not AW109_VS_HOT
        end

        if not IFR1_BTN_ALT and not IFR1_BTN_VS then
            IFR1_BOTH_BTN_ALT_VS = false
        end


        if AW109_IAS_HOT then
            set("aw109/cockpit/knob/apms/ias_drag", get("aw109/cockpit/knob/apms/ias_drag") + k1 + 10 * k0)
        elseif AW109_HDG_HOT then
            if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
                set("aw109/cockpit/button/rbp2/hdg_push", 1)
            elseif IFR1_LAST_BTN_KNOB and not IFR1_BTN_KNOB then
                set("aw109/cockpit/button/rbp2/hdg_push", 0)
            end

            if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                set("aw109/cockpit/button/rbp2/lnav", 1)
            elseif IFR1_LAST_BTN_SWAP and not IFR1_BTN_SWAP then
                set("aw109/cockpit/button/rbp2/lnav", 0)
            end

            set("aw109/cockpit/knob/rbp2/hdg/scroll", get("aw109/cockpit/knob/rbp2/hdg/scroll") + k1 + 10 * k0)
        elseif AW109_ALT_HOT then
            if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
                set("aw109/cockpit/button/rbp2/alt_push", 1)
            elseif IFR1_LAST_BTN_KNOB and not IFR1_BTN_KNOB then
                set("aw109/cockpit/button/rbp2/alt_push", 0)
            end

            if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                set("aw109/cockpit/button/rbp2/vnav", 1)
            elseif IFR1_LAST_BTN_SWAP and not IFR1_BTN_SWAP then
                set("aw109/cockpit/button/rbp2/vnav", 0)
            end

            set("aw109/cockpit/knob/rbp2/alt/scroll", get("aw109/cockpit/knob/rbp2/alt/scroll") + k1 + 10 * k0)
        elseif AW109_VS_HOT then
            set("aw109/cockpit/knob/apms/vs_drag", get("aw109/cockpit/knob/apms/vs_drag") + sum_knob)
        else
            if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
                set("aw109/cockpit/button/apms/rht_push", 1)
            elseif IFR1_LAST_BTN_KNOB and not IFR1_BTN_KNOB then
                set("aw109/cockpit/button/apms/rht_push", 0)
            end

            if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                set("aw109/cockpit/button/apms/hov", 1)
            elseif IFR1_LAST_BTN_SWAP and not IFR1_BTN_SWAP then
                set("aw109/cockpit/button/apms/hov", 0)
            end

            set("aw109/cockpit/knob/apms/rht_drag", get("aw109/cockpit/knob/apms/rht_drag") + k1 + 10 * k0)
        end
    end

    if IFR1_MODE == IFR1_MODE_VALUE_XPDR then -- Replaced by the right knob on the remote bug panel
        if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
            set("aw109/cockpit/button/rbp2/course_push", 1)
        elseif IFR1_LAST_BTN_KNOB and not IFR1_BTN_KNOB then
            set("aw109/cockpit/button/rbp2/course_push", 0)
        end

        if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
            set("aw109/cockpit/button/rbp2/set", 1)
        elseif IFR1_LAST_BTN_SWAP and not IFR1_BTN_SWAP then
            set("aw109/cockpit/button/rbp2/set", 0)
        end

        set("aw109/cockpit/knob/rbp2/course/scroll", get("aw109/cockpit/knob/rbp2/course/scroll") + k1)

        if k0 < 0 then
            set("aw109/cockpit/button/rbp2/brt_dec", 1)
            AW109_RESET_NEEDED = true
        elseif k0 > 0 then
            set("aw109/cockpit/button/rbp2/brt_inc", 1)
            AW109_RESET_NEEDED = true
        end
    end
end

function ifr1_send_leds(device)
    local led_val = 0
    led_val = led_val + (IFR1_LED_AP and 1 or 0)
    led_val = led_val + (IFR1_LED_HDG and 2 or 0)
    led_val = led_val + (IFR1_LED_NAV and 4 or 0)
    led_val = led_val + (IFR1_LED_APR and 8 or 0)
    led_val = led_val + (IFR1_LED_ALT and 16 or 0)
    led_val = led_val + (IFR1_LED_VS and 32 or 0)

    if IFR1_MODE_SHIFT then
        led_val = 0xff
    end

    if led_val ~= IFR1_LED_LAST_WRITE then
        hid_write(device, 11, led_val)
        IFR1_LED_LAST_WRITE = led_val
    end
end

function ifr1_ubyte_to_sbyte(usb)
    if usb > 127 then
        return -256 + usb
    else
        return usb
    end
end

function ifr1_process()
    ifr1_open()
    if IFR1_DEVICE ~= nil then
        -- read from the IFR-1. Since it is set to non-blocking, this will return with nov == 0 if there is no report available
        local nov, byte0, buttons0, buttons1, buttons2, byte5, knob0, knob1, mode_val = hid_read(IFR1_DEVICE, 8)

        if PLANE_AUTHOR == "X-Trident" and PLANE_DESCRIP == "AW109SP" then
            if IFR1_MODE == IFR1_MODE_VALUE_FMS1 or IFR1_MODE == IFR1_MODE_VALUE_FMS2 then
                IFR1_LED_AP = false
                IFR1_LED_HDG = false
                IFR1_LED_NAV = false
                IFR1_LED_ALT = false
                IFR1_LED_VS = false
                IFR1_LED_APR = false
            else
                IFR1_LED_AP = get("aw109/cockpit/capsule/apms/ias_on") > 0
                IFR1_LED_HDG = get("aw109/cockpit/capsule/apms/hdg_on") > 0
                IFR1_LED_NAV = get("aw109/cockpit/capsule/apms/nav_c") > 0 or get("aw109/cockpit/capsule/apms/nav_a") > 0
                IFR1_LED_ALT = get("aw109/cockpit/capsule/apms/alt_on") > 0
                IFR1_LED_VS = get("aw109/cockpit/capsule/apms/vs_on") > 0
                IFR1_LED_APR = get("aw109/cockpit/capsule/apms/app_c") > 0 or get("aw109/cockpit/capsule/apms/app_a") > 0

                local fraction = (sim_time - math.floor(sim_time))
                if AW109_IAS_HOT then
                    IFR1_LED_AP = fraction <= 0.5
                end

                if AW109_HDG_HOT then
                    IFR1_LED_HDG = fraction <= 0.5
                end

                if AW109_ALT_HOT then
                    IFR1_LED_ALT = fraction <= 0.5
                end

                if AW109_VS_HOT then
                    IFR1_LED_VS = fraction <= 0.5
                end
            end

            if (AW109_IAS_HOT or AW109_HDG_HOT or AW109_ALT_HOT or AW109_VS_HOT) and sim_time - AW109_TIME_LAST_ACTION > 5 then
                AW109_IAS_HOT = false
                AW109_HDG_HOT = false
                AW109_ALT_HOT = false
                AW109_VS_HOT = false
            end

            if (nov == 8) then
                AW109_TIME_LAST_ACTION = sim_time
                knob0 = ifr1_ubyte_to_sbyte(knob0)
                knob1 = ifr1_ubyte_to_sbyte(knob1)
                ifr1_acquire_buttons(buttons0, buttons1, buttons2, mode_val)

                ifr1_process_buttons_knobs_aw109sp(knob0, knob1)
            end

            if AW109_RESET_NEEDED then
                set("aw109/cockpit/button/rbp2/brt_dec", 0)
                set("aw109/cockpit/button/rbp2/brt_inc", 0)
                AW109_RESET_NEEDED = false
            end
        else -- Standard configuration
            IFR1_LED_AP = ap_on > 0
            IFR1_LED_HDG = ap_lateral == 1 or ap_lateral == 14
            IFR1_LED_NAV = ap_lateral == 2 or ap_lateral == 13
            IFR1_LED_ALT = ap_vertical == 6 or ap_alt_hold == 1
            IFR1_LED_VS = ap_vertical == 4
            IFR1_LED_APR = ap_appr > 0

            if IFR1_MODE == IFR1_MODE_VALUE_XPDR and xpdr_ident > 0 then
                local fraction = (sim_time - math.floor(sim_time))
                IFR1_LED_AP = fraction <= 0.5
            end

            if (nov == 8) then
                knob0 = ifr1_ubyte_to_sbyte(knob0)
                knob1 = ifr1_ubyte_to_sbyte(knob1)
                ifr1_acquire_buttons(buttons0, buttons1, buttons2, mode_val)

                ifr1_process_buttons_knobs_standard(knob0, knob1)
            end
        end
        ifr1_send_leds(IFR1_DEVICE)
    else

    end
end

ifr1_open()
do_every_frame('ifr1_process()')
do_on_exit("ifr1_close()")

-- INPUT (according to report, but read values don't match this format)
-- 32 bits (buttons)
-- 8 bits (knob 1)
-- 8 bits (knob 2)
-- 1 bits (?)
-- 1 bits (?)
-- 1 bits (?)
-- 5 bits (?)

-- OUTPUT
-- 8 bits (6 leds + 2 unused bits)

-- 0x05, 0x01,        // Usage Page (Generic Desktop Ctrls)
-- 0x09, 0x05,        // Usage (Game Pad)
-- 0xA1, 0x01,        // Collection (Application)
-- 0x85, 0x0B,        //   Report ID (11)
-- 0x05, 0x09,        //   Usage Page (Button)
-- 0x19, 0x01,        //   Usage Minimum (0x01)
-- 0x29, 0x20,        //   Usage Maximum (0x20)
-- 0x15, 0x00,        //   Logical Minimum (0)
-- 0x25, 0x01,        //   Logical Maximum (1)
-- 0x75, 0x01,        //   Report Size (1)
-- 0x95, 0x20,        //   Report Count (32)
-- 0x81, 0x02,        //   Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
-- 0x05, 0x01,        //   Usage Page (Generic Desktop Ctrls)
-- 0xA1, 0x02,        //   Collection (Logical)
-- 0x45, 0x00,        //     Physical Maximum (0)
-- 0x35, 0x00,        //     Physical Minimum (0)
-- 0x09, 0x37,        //     Usage (Dial)
-- 0x95, 0x02,        //     Report Count (2)
-- 0x75, 0x08,        //     Report Size (8)
-- 0x15, 0x81,        //     Logical Minimum (-127)
-- 0x25, 0x7F,        //     Logical Maximum (127)
-- 0x81, 0x06,        //     Input (Data,Var,Rel,No Wrap,Linear,Preferred State,No Null Position)
-- 0x05, 0x09,        //     Usage Page (Button)
-- 0x19, 0x01,        //     Usage Minimum (0x01)
-- 0x29, 0x03,        //     Usage Maximum (0x03)
-- 0x15, 0x00,        //     Logical Minimum (0)
-- 0x25, 0x01,        //     Logical Maximum (1)
-- 0x75, 0x01,        //     Report Size (1)
-- 0x95, 0x03,        //     Report Count (3)
-- 0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
-- 0x95, 0x01,        //     Report Count (1)
-- 0x75, 0x05,        //     Report Size (5)
-- 0x81, 0x03,        //     Input (Const,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
-- 0x05, 0x08,        //     Usage Page (LEDs)
-- 0x09, 0x2D,        //     Usage (Ready)
-- 0x15, 0x00,        //     Logical Minimum (0)
-- 0x25, 0x01,        //     Logical Maximum (1)
-- 0x95, 0x01,        //     Report Count (1)
-- 0x75, 0x08,        //     Report Size (8)
-- 0x91, 0x02,        //     Output (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position,Non-volatile)
-- 0xC0,              //   End Collection
-- 0xC0,              // End Collection

-- // 82 bytes

-- // best guess: USB HID Report Descriptor
