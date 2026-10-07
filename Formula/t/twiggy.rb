class Twiggy < Formula
  desc "Code size profiler for Wasm"
  homepage "https://github.com/rustwasm/twiggy"
  url "https://github.com/rustwasm/twiggy/archive/03aa20f06cd7aacb1c890c164037f860f16fa9f0.tar.gz"
  version "0.7.0" # bug report on the tag, https://github.com/rustwasm/twiggy/issues/750
  sha256 "e46bf450066e3eac0e95d06b3249760f4425e22477a55293566389ae27273fb3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7823c31a5d227a113051d194f260928b001671188bc97433050adc4dcdd02d7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d28a65ee343bfb205d42cd5af7a8a61c2b9f8e0627f1ad963d7a45fc3b70cce8"
    sha256 cellar: :any,                 arm64_linux:   "11a78aabd2c2c87cf294db11c42d31f4d427f127bcbe1a25a7016ba88df763e5"
    sha256 cellar: :any,                 x86_64_linux:  "28aabe04455bf82e903872cfada55cdb36c608f40646736ec3c3aaf706dd28a4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "twiggy")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/twiggy --version")

    system bin/"twiggy", "dominators", bin/"twiggy"
    system bin/"twiggy", "monos", bin/"twiggy"
  end
end
