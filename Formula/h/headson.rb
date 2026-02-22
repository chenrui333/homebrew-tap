class Headson < Formula
  desc "Structure-aware head/tail-style previews for JSON and YAML"
  homepage "https://github.com/kantord/headson"
  url "https://github.com/kantord/headson/archive/refs/tags/headson-v0.16.1.tar.gz"
  sha256 "485c221b28b361c9de2b8223f7985401d37f2c75a2870be6f59af4d83f499db7"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdb71323365cc056e7a55cc1c212d1f7f4ebb39c34e4dbad49552087d4824a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba90e30885d6b29ed23067c6f5172295751643ad637f538da250d65f5786f8a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf4c6995deeb6601f762ea1c5caf8477b74c3aaf06c54a9276bf1045203b3a6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1898a2f96a9febcc1836061943e0e89bd1815fc60ee5a2f22e5d70348fbb6fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a0243d67272b109ef2723107855eda5eca1a6f1503d43a94778cf6048afc417"
  end

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

    system "cargo", "install", *std_cargo_args
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
