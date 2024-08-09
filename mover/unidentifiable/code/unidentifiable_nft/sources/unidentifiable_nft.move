module unidentifiable_nft::unidentifiable_nft {
    
    use std::string::{String};
    use sui::package;
    use sui::display;

    public struct CourseInfo has key, store {
        id: UID,
        name: String,
        image_url: String,
        time: u64,
    }

    public struct UNIDENTIFIABLE_NFT has drop {}

    fun init(otw: UNIDENTIFIABLE_NFT, ctx: &mut TxContext) {
        let keys: vector<String> = vector [
            b"name".to_string(),
            b"image_url".to_string(),
            b"description".to_string(),
            b"creator".to_string(),
            b"project_url".to_string(),
        ];

        let values: vector<String> = vector [
            b"{name} Course Series".to_string(),
            b"{image_url}".to_string(),
            b"welcome to the {name} course series, it costs {time} hours to complete!".to_string(),
            b"UNIDENTIFIABLE".to_string(),
            b"https://www.hackquest.io/zh".to_string(),
        ];
        
        let publisher: sui::package::Publisher = package::claim(otw, ctx);

        let mut display: sui::display::Display<CourseInfo> = display::new_with_fields(
            &publisher, keys, values, ctx
        );

        display::update_version(&mut display);

        transfer::public_transfer(publisher, ctx.sender());
        transfer::public_transfer(display, ctx.sender());
    }

    public entry fun mint(name: String, image_url: String, time: u64, receipt: address, ctx: &mut TxContext){
        let id: sui::object::UID = object::new(ctx);
        let course: unidentifiable_nft::unidentifiable_nft::CourseInfo = CourseInfo { id, name, image_url, time };
        transfer::transfer(course, receipt);
    }
}