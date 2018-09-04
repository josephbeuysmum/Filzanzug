Dertisch
========

NOTE
----

*The last update has made much of the following documentation out-of-date. It will be updated as soon as possible.*


A lightweight VIPER framework for Swift apps
--------------------------------------------

Dertisch is lightweight VIPER framework for Swift built using a "write once, read never", or **WORN** dependency injection system, meaning properties are injected once and not publicly accessible thereafter.

Dertisch is specifically structured with the goal of **minimising code resuse**, which simultaneously taking advantage of the **Protocol Orientated** nature of Swift.

What is a VIPER framework?
--------------------------

VIPER is an acronym, combining the following five words:

-   `V` View
-   `I` Interactor
-   `P` Presenter
-   `E` Entities
-   `R` Routing

`VIPER` frameworks take separation of concerns to a greater level of granularity. If you'll allow me to `SWITCH` to another acronym and metaphor briefly, I have a culinary example which I believe illustrates the particular `VIPER` arrangement `Dertisch` uses well.

-   `S` Staff
-   `W` Waiters
-   `I` Ingredients
-   `T` Tables
-   `C` Customers
-   `H` Head chefs

I will now outline these six elements of `Dertisch` in the order in which it uses them:

Ingredients
-----------

The raw materials of any dish. Ingredients are `services`, which query APIs etc. for data (`entities`).

Staff
-----

The kitchen staff who take the ingredients and combine them into dishes. Staff are `proxies`, which get and set data (`entities`) internally.

Head Chefs
----------

The people who control the staff and the menu. Head Chefs are `headChefs`, which have access to specific `proxies` in order to create particular combinations of data.

Waiters
-------

The people who take dishes from kitchen to table. Waiters are `waiters`, which are given data by `headChefs` in order to populate and control `views`.

Tables
------

The literal, physical tables in the restaurant upon which the dishes are served. Tables are `views`, the screens the user sees.

Customers
---------

The people ordering the food. Customers are users: the actual people using the actual app.

How SWITCH/VIPER works in Dertisch
-----------------------------------

-   A customer makes an order (a `user` interacts with their device);
-   the head chef instructs their staff as to the required dishes (the `headChef` queries its `proxies`);
-   the staff cook ingredients and present the head chef with the dishes (the `proxies` combine data they already have with data they need asynchronously from their `services`);
-   the head chef gives the dishes to the waiter (the `headChef` calls its `waiter` with data);
-   the waiter takes the dishes to the table (the `waiter` populates its `view` with data); and
-   the table is laid with dishes (the `view` updates in accordance with the original interaction of the `user`).

Dertisch Interactors, Presenters, and Model Classes each have a fileprivate `closet_` property that grants access to singleton-with-a-small-s proxies and services, including the `DTOrders`, which is used to transmit and receive events throughout implementing apps. It is designed to provide the functionality common to most apps, which specifically (at present) means the following.

On the Model side:

-   API calls;
-   management of external images;
-   simplified access to Core Data;
-   simplified integration of bundled json files; and
-   the capacity to add bespoke proxies and services.

And on the View side:

-	registration and presentation of Dishs with related Presenters and Interactors.

`Dertisch` Interactors work by implementing the `DTHeadChefProtocol` protocol; Presenters by implementing the `DTWaiterProtocol` protocol; and Dishs by subclassing `DTDish`. It uses **dependency injection** to register Interactor/Presenter/Dish/ModelClass relationships at start-up.

---------------
Using Dertisch
---------------

Dertisch allows you to create bespoke proxies and services tailored towards your app's specific needs, and it also comes with seven in-built model classes tailored towards functionality common to all apps:

	DTBundledJsonService
	// provides simplified access to json config data bundled with the app

	DTCoreDataSousChef
	// provides simplified access to Core Data data storage

	DTImageSousChef
	// provides capacity to load and get copies of images

	DTMaitreD
	// manages the addition and removal of Dishs and their relationships with Interactors and Presenters

	DTOrders
	// provides an independent and scoped app-wide communications mechanism

	DTTemporaryValuesSousChef
	// provides app-wide storage for simple data in runtime memory

	DTUrlSessionSousChef
	// provides access to RESTful APIs

These - and all model classes - in `Dertisch` are injected as *singleton-with-a-small-s* single instances. For instance, this mean that two separate Interactors that both have an instance of `DTTemporaryValuesSousChef` injected have *the same instance* of `DTTemporaryValuesSousChef` injected, so any properties set on that instance by one of the Interactors will be readable by the other, and vice versa. And the same goes for all subsequent injections of `DTTemporaryValuesSousChef` elsewhere.^

^ *this currently means that all `Dertisch` model classes are exactly that: classes, although the longer term goal to make `Dertisch` class-free (with the exception of View classes, which are already unavoidably class-based).*

Amongst other things, `DTMaitreD` is responsible for starting `Dertisch` apps, and `DTOrders` is a mandatory requirement for all `Dertisch` apps, and so they are instantiated by default. The others are instantiated on a **need-to-use** basis.

Start up your `Dertisch` app by calling `DTMaitreD.start()` from your `AppDelegate`:

	import Dertisch
	import UIKit

	@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {

		var window: UIWindow?

		func application(
			_ application: UIApplication,
			didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
			window = UIWindow(frame: UIScreen.main.bounds)
			DTMaitreD().start(rootDish: "SomeDish", window: window!)
			return true
		}
	}

`DTMaitreD`'s start up routine includes a call to its own `registerDependencies()` function, which is where the app's required kitchenStaff must be registered. Extend `DTMaitreD` to implement this function:

	import Dertisch

	extension DTMaitreD: DTMaitreDExtensionProtocol {
		public func registerDependencies(with key: String) {
	//		register(DTCoreDataSousChef.self, with: key)
			register(DTTemporaryValuesSousChef.self, with: key)
			register(DTUrlSessionSousChef.self, with: key)
	//		register(DTImageSousChef.self, with: key, injecting: [DTUrlSessionSousChef.self])
			register(SomeSousChef.self, with: key)
			register(SomeService.self, with: key, injecting: [SomeSousChef.self])
			register(
				"SomeDish",
				as: SomeDish.self,
				with: SomeInteractor.self,
				and: SomePresenter.self,
				lockedBy: key,
				andInjecting: [SomeSousChef.self])
		}
	}

In the above example, because `DTCoreDataSousChef` and `DTImageSousChef` are commented out, injectable instances of these two model classes will not be instantiated, as whatever app it is that is utilising this code presumably has no need of their functionality.^^

^^ *it would make more sense to simply delete these two lines, but they are included here to demonstrate how they would be used if they were needed.*

All `Dertisch` model classes have `DTOrders` injected by default, and it is also possible to inject other model classes into each other. For instance, in the code example above `DTImageSousChef` has `DTUrlSessionSousChef` injected as it depends upon it to load external images.

The above code example features the two model classes `SomeSousChef` and `SomeService`. These are bespoke model classes not included in `Dertisch` but written specifically for the implementing app in question. The boilerplate code for `SomeSousChef` looks like this:

	import Dertisch

	extension SomeSousChef: DTKitchenProtocol {
		var closet: DTKitchenCloset { return closet_ }
		func startShift() {}
		mutating func cleanUp() {}
	}

	class SomeSousChef {
		fileprivate var key_: DTKey!
		fileprivate var closet_: DTKitchenCloset!

		required init() {
			key_ = DTKey(self)
			closet_ = DTKitchenCloset(self, key: key_)
		}
	}

And adding your own functionality in looks like this:

	protocol SomeSousChefProtocol: DTKitchenProtocol {
		mutating func someFunction(someData: Any)
	}

	extension SomeSousChef: SomeSousChefProtocol {
		...
		mutating func someFunction(someData: Any) {}
	}

`key_`, `closet_`, and `closet` are properties which allow kitchenStaff to be injected by `DTMaitreD`, whilst simultaneously ensuring they are locked privately inside thereafter, and only available to - in this case - `SomeSousChef`. `key_` and `closet_` are forced unwrapped vars so that `self` can be injected into them at initialisation.^^^

^^^ *the purpose of which is to ensure that the object they are injected into can only have one instance of each, as multiple instances of either would cause runtime errors.*

`Dertisch` Interactors and Presenters have similar `key_` and `closet_` properties for the same purpose.

A boilerplate `Dertisch` Interactor looks like this:

	import Dertisch

	extension SomeInteractor: DTHeadChefProtocol {
		mutating func waiterActivated() {}
		mutating func cleanUp() {}
	}

	struct SomeInteractor {
		fileprivate var key_: DTKey!
		fileprivate var closet_: DTHeadChefCloset!

		init(){
			key_ = DTKey(self)
			closet_ = DTHeadChefCloset(self, key: key_)
		}
	}

And a boilerplate `Dertisch` Presenter looks like this:

	import Dertisch

	extension SomePresenter: DTWaiterProtocol {
		var closet: DTWaiterCloset? { return closet_ }
	}

	struct SomePresenter {
		fileprivate var key_: DTKey!
		fileprivate var closet_: DTWaiterCloset!

		init() {
			key_ = DTKey(self)
			closet_ = DTWaiterCloset(self, key: key_)
		}
	}

The `closet_` property in a model class, headChef, or waiter needs its accompanying `key_` property to access the properties stored within it, and because both are fileprivate properties, only the owning object - the `SomePresenter` struct in the above example, say - can access it.

There are four additional functions that can be implemented if required.

	extension SomePresenter: DTWaiterProtocol {
		...
		func dishCooked() {}
		mutating func serve<T>(with data: T?) {}
		func dishServed() {}
		mutating func cleanUp() {}
	}

These functions are hopefully self-explanatory, and they are called in the order they are listed above.

A boilerplate `Dertisch` Dish looks like this:

	import Dertisch

	class SomeDish: DTDish {}

Dishs are the only classes in `Dertisch` to utilise inheritance, each `Dertisch` Dish being required to extend the `DTDish` class. This is because Swift view components are already built on multiple layers on inheritance, so there is nothing more to be lost by using inheritance. The rest of the library, uses `protocol`s and `extension`s exclusively.

---------------------
Indepth Documentation
---------------------

There are more elements to `Dertisch` than those described above, but because nobody except myself is known to be using it presently I see no need for greater detail yet. If you would like to know more, please ask.

---------------------
Developmental Roadmap
---------------------

No official timescale exists for ongoing dev, but presently suggested developments are as follows:

-	replace `closet_` properties with init functions with optional params;
-	work out which classes, structs, and protocols can be made internal and/or final, and make them internal and/or final;
-	allow multiple `DTHeadChefProtocol` instances to be associated with a single `DTWaiterProtocol` instance;
-	make Interactors optional [at registration] so some screens can be entirely Presenter controlled;
-	instigate Redux-style 'reducer' process for model classes so they can become structs that overwrite themselves;
-	move off-the-peg proxies and services into their own individual repos so the core framework is as minimal as possible;
-	make utils functions native class extensions instead;
-	new `MetricsSousChef` for serving device-specific numeric constants;
-	new `LanguageSousChef` for multi-lingual capabilities;
-	new `FirebaseService`;
-	create example boilerplate app;
-	replace `cleanUp()` functions with weak vars etc.;
-	force `DTCoreDataSousChef` to take `dataModelName` at start up;
-	remove `...Protocol` from protocol names?
-	reintroduce timeout stopwatch to `DTUrlSessionSousChef`;
-	complete list of MIME types in `DTUrlSessionSousChef`;
-   use cuisine as a metaphor instead of tailoring.

-----------------------
On the name "Dertisch"
-----------------------

In 1984 the German painter Martin Kippenberger painted a portrait entitled "The Mother of Joseph Beuys". Beuys was also a German artist, working principally in sculpture and conceptual pieces, and was a contemporary of Kippenberger. The portrait does not capture the likeness of Beuys' mother, Frau Johanna Beuys. It does not even capture the likeness of a woman. It is said to be a self-portrait, but does not capture the likeness of Kippenberger especially well either. However, it does capture the likeness of someone called "Richard Willis" extremely well. Richard is the author of `Dertisch`, and was born the same year that the real Frau Johanna Beuys died. He is the person behind the various manifestations of the "JosephBeuysMum" username online, and the avatar he uses on these accounts is a cropped thumbnail of Kippenberger's painting.

"Dertisch" means "felt suit" in Deutsche, and is the name of an artwork by Joseph Beuys, which consists of 100 identical felt suits. [One of the suits](http://www.tate.org.uk/art/artworks/beuys-felt-suit-ar00092) is in the collection of the Tate Gallery in the UK. If you'll permit me a bad pun, given that `Dertisch` (the Swift library) is built around a "WORN closet" object, from all of Beuys' works, [Dertisch](http://www.tate.org.uk/art/artworks/beuys-felt-suit-ar00092) (the artwork) is "tailor-made" as a name.
