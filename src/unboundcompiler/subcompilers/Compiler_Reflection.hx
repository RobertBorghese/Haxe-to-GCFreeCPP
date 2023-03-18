// =======================================================
// * Compiler_Reflection
//
// This sub-compiler is used to handle compiling anything
// related to Haxe reflection.
//
// This mainly involves compiling C++ to make the `Type`,
// `Reflect`, `Dynamic` and `Class<T>` types function
// properly.
// =======================================================

package unboundcompiler.subcompilers;

#if (macro || ucpp_runtime)

@:allow(unboundcompiler.UnboundCompiler)
@:access(unboundcompiler.UnboundCompiler)
class Compiler_Reflection extends SubCompiler {
	public function typeUtilHeaderContent() {
		IComp.addInclude("array", true, true);
		IComp.addInclude("string", true, true);

		return "// ---------------------------------------------------------------------
// haxe::_class<T>
//
// A class used to access reflection information regarding Haxe types.
// ---------------------------------------------------------------------

namespace haxe {

template<typename T>
struct _class;

template<std::size_t sf_size, std::size_t if_size, typename Super = void>
struct _class_data {
	using super_class = _class<Super>;
	constexpr static bool has_super_class = std::is_same<Super, void>::value;

	const char* name = \"<unknown>\";
	const std::array<const char*, sf_size> static_fields;
	const std::array<const char*, if_size> instance_fields;
};

#define DEFINE_CLASS(cls_name, sf_size, static_fields, if_size, instance_fields) \\
	constexpr static _class_data<0, 0> data {\\
		cls_name,\\
		static_fields,\\
		instance_fields\\
	};\\
	\\
	std::string toString() {\\
		return std::string(\"Class<\") + data.name + \">\";\\
	}

template<typename T>
struct _class {
	DEFINE_CLASS(\"unknown type\", 0, {}, 0, {})
};

}

// ---------------------------------------------------------------------
// haxe::_unwrap_class
// ---------------------------------------------------------------------

namespace haxe {

template<typename T>
struct _unwrap_class {
	using inner = T;
};

template<typename T>
struct _unwrap_class<_class<T>> {
	using inner = typename _unwrap_class<T>::inner;
};

}";
	}
}

#end