import Selector from "./selector.js";

$(function() {
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

    // function select(type="all") {
    //     if(type == "all") {
    //         $(".selector.main").prop("checked", true);
    //         $(".selector[type=checkbox]").each((i, e) => {
    //             if(!$(e).hasClass("main") && !e.checked) {
    //                 e.checked = true;
    //                 $(e).trigger("change");
    //             }
    //         });
    //     } else if(type == "none") {
    //         $(".selector.main").prop("checked", false);
    //         $(".selector[type=checkbox]").each((i, e) => {
    //             if(!$(e).hasClass("main") && e.checked) {
    //                 e.checked = false;
    //                 $(e).trigger("change");
    //             }
    //         });
    //     } else if(type == "inverse") {
    //         $(".selector.main").prop("checked", false);
    //         $(".selector[type=checkbox]").each((i, e) => {
    //             if(!$(e).hasClass("main")) {
    //                 e.checked = !e.checked;
    //                 $(e).trigger("change");
    //             }
    //         });
    //     }
    // }

    // function updateSelected() {
    //     let selected = [];
    //     $(".selector[type=checkbox]").each((i, e) => {
    //         if(!$(e).hasClass("main") && e.checked) {
    //             selected.push(e.value);
    //         }
    //     });
    //     $("#selected").attr("value", selected.join(","));
    // }

    // $(".selector[type=checkbox]").on("change", function() {
    //     if($(this).hasClass("main")) {
    //         let value = $(this).attr("value");
    //         if(this.checked) select("all");
    //         else select("none");
    //     } else updateSelected();
    // });

    // $(".select").on("click", function() {
    //     let type = $(this).data("select-type");
    //     select(type);
    // });

    let menuItemCount = 0;

    function updateMenuItems() {
        let val = $(".menu-item-quantity input").toArray()
            .map((e) => e.value).join(",");
        $("#menu_items").val(val);
    }

    function setupMenuItems() {
        let i = 0;
        for(let item of $(".menu-item")) {
            let qty = "quantity-" + i;
            let pro = "product-" + i;

            $(item).find(".menu-item-quantity label").attr("for", qty);
            $(item).find(".menu-item-quantity input")
                .attr("id", qty).removeAttr("name")
                .off("input")
                .on("input", updateMenuItems);

            // TODO: Set also the dropdown product.

            $(item).find(".button.add").off("click");
            $(item).find(".button.add").on("click", function() {
                let item = $(this).closest(".menu-item");
                let clone = item.clone()
                clone.insertAfter(item);
                clone.find(".menu-item-quantity input").val(1);
                setupMenuItems();
            });
            
            let rm = $(item).find(".button.remove");
            rm.off("click");
            rm.addClass("disabled");
            if($(item).siblings().length != 0) {
                rm.removeClass("disabled");
                $(item).find(".button.remove").on("click", function() {
                    let item = $(this).closest(".menu-item");
                    item.remove();
                    setupMenuItems();
                });
            }
            
            let up = $(item).find(".button.move-up");
            up.off("click");
            up.addClass("disabled");
            if($(item).prev().length != 0) {
                up.removeClass("disabled");
                up.on("click", function() {
                    let item = $(this).closest(".menu-item");
                    let target = item.prev();
                    $(item).hide().insertBefore(target).show("fast");
                    setupMenuItems();
                });
            }

            let dn = $(item).find(".button.move-down");
            dn.off("click");
            dn.addClass("disabled");
            if($(item).next().length != 0) {
                dn.removeClass("disabled");
                dn.on("click", function() {
                    let item = $(this).closest(".menu-item");
                    let target = item.next();
                    $(item).hide().insertAfter(target).show("fast");
                    setupMenuItems();
                });
            }

            i++;
        }

        menuItemCount = i;
    }

    setupMenuItems();

    const selector = new Selector("0");
});