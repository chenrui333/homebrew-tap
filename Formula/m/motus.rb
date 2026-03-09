class Motus < Formula
  desc "Dead simple password generator"
  homepage "https://github.com/oleiade/motus"
  url "https://github.com/oleiade/motus/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "eaa547e0821906cba7553ff7a51309cc39d450b215748a907bd7db1614ce0c85"
  license "AGPL-3.0-only"
  head "https://github.com/oleiade/motus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7598c46b813e3705d78fbc6c9b53ed0d97d4ee3519c51e8518a3aa65af26a6c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "234192f8f44bec41f461c85594d342c69529d10f911b4f0224832d2c8431dc04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "208ed5ebe18819c514e08f7b8a54d5dd789b64dd2801020a586caf2a99ff35e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b94fecef2102a730443f6abc46f498fdc11fdaad599b40413db7e5524402e0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "646350e598b76a31fea15fdf4b7306b25f71e5053fe45f0d18a746fbd5274e20"
  end

  depends_on "rust" => :build

  def install
    # The clipboard feature pulls in GUI-specific X11 clipboard support on Linux.
    system "cargo", "install", *std_cargo_args(path: "crates/motus-cli"), "--no-default-features"
  end

  test do
    expected = '{"kind":"random","password":"BC6%!vMSga9A"}'
    output = shell_output("#{bin}/motus --seed 42 --output json random -c 12 -n -s").strip
    assert_equal expected, output
  end
end
