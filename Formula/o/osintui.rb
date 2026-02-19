class Osintui < Formula
  desc "Open Source Intelligence Terminal User Interface"
  homepage "https://github.com/wssheldon/osintui"
  url "https://static.crates.io/crates/osintui/osintui-0.1.1.crate"
  sha256 "732444225882845e6148e0fcc1ab4351454180014eb605f2133c490a1314b703"
  license "MIT"
  head "https://github.com/wssheldon/osintui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef25b21fade83dab585835cf9d125855aef60416e44b2e05256497f815e006db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b47941171513d26b4dbb1f9138f01c7c5c2a03582a122067ee1cb9c73f898a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd41c0884965e6763babe2941eb88b1db99b654148212d47af8aa81ae1a71a72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14ab6854e6aff4a587296aa684451cdae0be05e7f139221db61abac2939e3a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81dae5c17fd1ebc3f9cbe05c9cf021ae33ae557b93244176a7036a669b81a971"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"osintui", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Config will be saved to", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
