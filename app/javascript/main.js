$(() => {
    const parenRegex = /\(([^)]+)\)/;

    $.fn.api.settings.api = {
        'regions' : 'https://ph-locations-api.buonzz.com/v1/regions',
        'provinces' : 'https://ph-locations-api.buonzz.com/v1/provinces',
        'cities' : 'https://ph-locations-api.buonzz.com/v1/cities',
        'barangays' : 'https://ph-locations-api.buonzz.com/v1/barangays',
    };

    $(".ui.dropdown").dropdown();

    $('.message .close').on('click', function() {
        $(this).closest('.message').transition('fade');
    });

    let regions = [];
    function getRegion() {
        let region = $("#region").dropdown("get value");
        region = regions.filter((e) => {
            return e.name == region;
        });
        return region[0];
    }

    $("#region").dropdown({
        apiSettings: {
            action: "regions",
            cache: false,
            beforeSend: function(settings) {
                settings.urlData = {
                }
                return settings;
            },
            onResponse: function(response) {
                let res = {
                    success: true,
                    results: []
                }
                
                regions.length = 0;
                for(let d of response.data) {
                    regions.push(d);
                    res.results.push({
                        value: d.name,
                        name: parenRegex.exec(d.name)[1],
                    });
                }
                return res;
            }
        },
        saveRemoteData: false,
        onChange: function(value, text, $choice) {
            // toggleBookingSeat();
        }
    });

    let provinces = [];
    function getProvince() {
        let province = $("#province").dropdown("get value");
        province = provinces.filter((e) => {
            return e.name == province;
        });
        return province[0];
    }

    $("#province").dropdown({
        apiSettings: {
            action: "provinces",
            cache: false,
            beforeSend: function(settings) {
                settings.urlData = {
                }
                return settings;
            },
            onResponse: function(response) {
                let res = {
                    success: true,
                    results: []
                }

                let region = getRegion();
                provinces.length = 0;
                if(region != null) {
                    for(let d of response.data) {
                        if(d.region_code != region.id) continue;
                        provinces.push(d);
                        res.results.push({
                            value: d.name,
                            name: d.name,
                        });
                    }
                }
                return res;
            }
        },
        saveRemoteData: false,
        onChange: function(value, text, $choice) {
            // toggleBookingSeat();
        }
    });
    
    let cities = [];
    function getCity() {
        let city = $("#city").dropdown("get value");
        city = cities.filter((e) => {
            return e.name == city;
        });
        return city[0];
    }

    $("#city").dropdown({
        apiSettings: {
            action: "cities",
            cache: false,
            beforeSend: function(settings) {
                settings.urlData = {
                }
                return settings;
            },
            onResponse: function(response) {
                let res = {
                    success: true,
                    results: []
                }

                let region = getRegion();
                let province = getProvince();
                cities.length = 0;
                if(region != null && province != null) {
                    for(let d of response.data) {
                        if(d.region_code != region.id || d.province_code != province.id)
                            continue;
                        cities.push(d);
                        res.results.push({
                            value: d.name,
                            name: d.name,
                        });
                    }
                }
                return res;
            }
        },
        saveRemoteData: false,
        onChange: function(value, text, $choice) {
            // toggleBookingSeat();
        }
    });
    
    // let barangays = [];
    // function getBarangay() {
    //     let barangay = $("#barangay").dropdown("get value");
    //     barangay = barangays.filter((e) => {
    //         return e.name == barangay;
    //     });
    //     return barangay[0];
    // }

    // $("#barangay").dropdown({
    //     apiSettings: {
    //         action: "barangays",
    //         cache: false,
    //         beforeSend: function(settings) {
    //             settings.urlData = {
    //             }
    //             return settings;
    //         },
    //         onResponse: function(response) {
    //             let res = {
    //                 success: true,
    //                 results: []
    //             }

    //             let region = getRegion();
    //             let province = getProvince();
    //             let city = getCity();
    //             barangays.length = 0;
    //             if(region != null && province != null && city != null) {
    //                 for(let d of response.data) {

    //                     if(d.region_code != region.id ||
    //                         d.province_code != province.id ||
    //                         d.city_code != city.id)
    //                         continue;
    //                     barangays.push(d);
    //                     res.results.push({
    //                         value: d.name,
    //                         name: d.name,
    //                     });
    //                 }
    //             }
    //             return res;
    //         }
    //     },
    //     saveRemoteData: false,
    //     onChange: function(value, text, $choice) {
    //         // toggleBookingSeat();
    //     }
    // });
})