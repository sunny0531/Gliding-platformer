use godot::prelude::*;
#[derive(GodotClass)]
#[class(base = Node2D)]
struct Level {
    #[export]
    gravity: f64,
    #[export]
    gliding_gravity:f64,
}

#[godot_api]
impl Level {

}
#[godot_api]
impl Node2DVirtual for Level {
    fn init(base: Base<Self::Base>) -> Self {
        Self {
            gravity: 9.8,
            gliding_gravity: 5.0,
        }
    }
}