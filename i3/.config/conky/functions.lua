
function conky_variable_processors()
        first_second_core = "${color}${font} CPU1: ${cpu cpu1}% ${freq_g 1}GHz  CPU2: ${cpu cpu2}% ${freq_g 2}GHz"

        third_fourth_core = "${color}${font} CPU3: ${cpu cpu3}% ${freq_g 3}GHz  CPU4: ${cpu cpu4}% ${freq_g 4}GHz"

        menv = os.getenv('MACHINE_ENV')
        if menv == 'desktop' then
                return first_second_core .. "\n" .. third_fourth_core
        else
                return first_second_core
        end
end

function conky_is_wireless()
        wirless_info = "\n${color}${font}直 ${wireless_essid ${gw_iface}} ${wireless_link_bar 12,100 ${gw_iface}} ${wireless_link_qual_perc ${gw_iface}}%"
        menv = os.getenv('MACHINE_ENV')
        if menv == 'laptop' then
                return wirless_info
        else
                return ""
        end
end

