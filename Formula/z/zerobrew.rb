class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "696fb9028a4b553fe87eb58af81f44f0676312e07ed89be78fc0886f1f3127a5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5a15a9d00a94ffc254db1c8790e412b4334d7a908d5e2f002c897dedab0a351"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3329972ea619f88929d731437e1b0e0358af752e1e637a84c48827508fc2287c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c6aa7f0ccb50cf73262048949e80e8a8d86aae56203db53b4aa7117f09ce6f"
    sha256 cellar: :any,                 arm64_linux:   "50af752dabfdbf827822b55c8eb9d3ba7ab0a01ea324984e54ebdb7ef7e28341"
    sha256 cellar: :any,                 x86_64_linux:  "4796865c2678b1977c4078ddd03e8c01cec9aed15782b2f6dd29689af343fb2a"
  end

  depends_on "rust" => :build

  def install
    inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
