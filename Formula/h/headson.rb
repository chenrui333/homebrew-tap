class Headson < Formula
  desc "Structure-aware head/tail-style previews for JSON and YAML"
  homepage "https://github.com/kantord/headson"
  url "https://github.com/kantord/headson/archive/refs/tags/headson-v0.16.1.tar.gz"
  sha256 "485c221b28b361c9de2b8223f7985401d37f2c75a2870be6f59af4d83f499db7"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.linux?
      zlib = Formula["zlib-ng-compat"]
      ENV["ZLIB_ROOT"] = zlib.opt_prefix.to_s
      ENV.append_path "PKG_CONFIG_PATH", zlib.opt_lib/"pkgconfig"
      ENV.append "LDFLAGS", "-L#{zlib.opt_lib}"
      ENV.append "CPPFLAGS", "-I#{zlib.opt_include}"
    end

    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {"name":"demo","items":[1,2,3],"meta":{"enabled":true}}
    JSON

    assert_match version.to_s, shell_output("#{bin}/hson --version")
    output = shell_output("#{bin}/hson -c 120 sample.json")
    assert_match "name", output
  end
end
