class Twiggy < Formula
  desc "Code size profiler for Wasm"
  homepage "https://rustwasm.github.io/twiggy/"
  url "https://github.com/rustwasm/twiggy/archive/03aa20f06cd7aacb1c890c164037f860f16fa9f0.tar.gz"
  version "0.7.0" # bug report on the tag, https://github.com/rustwasm/twiggy/issues/750
  sha256 "e46bf450066e3eac0e95d06b3249760f4425e22477a55293566389ae27273fb3"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "twiggy")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/twiggy --version")

    system bin/"twiggy", "dominators", bin/"twiggy"
    system bin/"twiggy", "monos", bin/"twiggy"
  end
end
