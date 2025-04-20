class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "69a7ac90d488351e8b675bff4091a9cb385211e1fa3621c3f706a1260c7d8b27"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e0e5d01f1e35aacdbbc5f1f1f8100dac47e9c763c042ceec96569d4ed51191a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7798dd2581ced467cae032f758d81c7285676fe548119b2b01b1d44fd010348"
    sha256 cellar: :any_skip_relocation, ventura:       "c1a6532cdb1d3711642d1f8ff3fb3807b237fd0eecc5060a003934da18f3d91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b17b0c842c5138d66cb1f9e3952ccb1165fdc9dde83bce548e6247ba0e437088"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tuono")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuono --version")

    system bin/"tuono", "new", "my-app"
    assert_path_exists testpath/"my-app/package.json"
  end
end
