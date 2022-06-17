import Selector from "./selector.js";
import List from "./list.js";

$(function() {
    const parenRegex = /\(([^)]+)\)/;

    $.fn.api.settings.api = {
        'regions' : 'https://ph-locations-api.buonzz.com/v1/regions',
        'provinces' : 'https://ph-locations-api.buonzz.com/v1/provinces',
        'cities' : 'https://ph-locations-api.buonzz.com/v1/cities',
        'barangays' : 'https://ph-locations-api.buonzz.com/v1/barangays',

        'api' : '/api?operation={operation}&args={args}'
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

    $(".image-upload").on("change", (ev) => {
        let files = ev.currentTarget.files;
        if(files.length > 0) {
            $("#image-previews-parent").removeAttr("style");
            $("#image-previews .image-preview").remove();
            for(file of files) {
                img = $("#image-preview").clone().appendTo("#image-previews");
                id = img.attr("id");
                img.removeAttr("id");
                img.addClass(id);
                img.removeAttr("style");
                img.children("img").attr("src", URL.createObjectURL(file));
            }
        } else {
            $("#image-previews-parent").css("display", "none");
        }
    });

    const selector = new Selector("0");
    $(".select.all").on("click", () => selector.selectAll());
    $(".select.none").on("click", () => selector.deselectAll());
    $(".select.inverse").on("click", () => selector.invertSelection());

    if($("#menu-form").length != 0) {
        function updateBaseFromMenu() {
            const ls = $.map($(".product-quantity").toArray(), function(e, i) {
                const qu = Math.max(parseInt($(e).val()), 0);
                const id = $(e).data("product-id");

                return [[id, qu]];
            }).filter((v, i) => v[1] > 0);
            const val = ls.map((v, i) => v.join("-")).join(",");
            
            $("#menu_items").val(val);
        }

        $(".product-quantity").on("change", updateBaseFromMenu);
    }



    

    $(".dropdown.kiosk").dropdown({
        apiSettings: {
            action: "api",
            cache: false,
            beforeSend: function(settings) {
                settings.urlData = {
                    operation: "get",
                    args: "kiosks"
                }
                return settings;
            },
            onResponse: function(response) {
                let res = {
                    success: true,
                    results: []
                }

                for(let k in response) {
                    d = response[k]
                    res.results.push({
                        value: d.id,
                        name: d.name,
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

    if($("#kiosk-purchase-form").length != 0) {
        function updateBaseFromPurchase() {
            const qu = Math.max(parseInt($("#purchase-quantity").val()), 0);
            const val = qu != 0 ?
                selector.selectedValues.map((v, i) => `${v}-${qu}`).join(",") :
                "";
            
            $("#purchase_orders").val(val);
        }

        $("#purchase-quantity").on("change", updateBaseFromPurchase);
        $(selector.subs).on("change", updateBaseFromPurchase);
    }


    $(".purchase-quantity").on("change", function() {
        const id = $(this).data("purchase-id");
        const pr = parseFloat($(this).data("purchase-price"));
        const qt = Math.max(parseInt($(this).val()), 1);
        
        const th = this;
        const jr = $.post("/api", {
            operation: "post",
            args: {
                type: "update-purchase",
                search: {id},
                values: {
                    quantity: qt
                }
            }
        }).done(function() {
            const total = (pr * qt).toFixed(2);
            const tr = $(th).closest("tr");

            tr.find(".purchase-quantity").data("purchase-total", total);
            tr.find(".purchase-total").text(total);

            updateGrandTotal();
        });
    });

    function updateGrandTotal() {
        const gtotal = $.map($(".purchase-quantity"), function(v, i) {
            const tr = $(v).closest("tr");
            if(!tr.find(".selector").is(":checked")) return 0;
            return parseFloat($(v).data("purchase-total"));
        }).reduce((p, c) => p + c, 0).toFixed(2);

        $(".purchase-grand-total").text(gtotal);
    }

    $(selector.subs).on("change", updateGrandTotal);

    if($("#purchase-form").length != 0)  {
        $(selector.subs).on("change", function() {
            $("#purchase_orders").val(selector.selectedValues.join(","));
        });
        selector.selectAll();
    }
});