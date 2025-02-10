class Ohy < Formula
  desc "Lightweight, Privacy-First CLI for Packaging Web into Desktop Apps"
  homepage "https://github.com/ohyfun/ohy"
  url "https://github.com/ohyfun/ohy/archive/b5676863b12308bb68332b7847764f69a9eb60bb.tar.gz"
  version "0.0.0"
  sha256 "2a4d81d68f429cb30b070ed03f1cf02c38b2da4317d5fe91e29be37decc51734"
  license "MIT"

  livecheck do
    skip "no tagged releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "861de6548c75b3b48ec1e13b591d8725c5d70e6e45e0dd2feab682d160e6132a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b301210aad7569f4cabaaf29c6adb993a0ab2edf586fc538f067b363f9f9495"
    sha256 cellar: :any_skip_relocation, ventura:       "80afe741ee00180a71244227105e88bfcd8e94b8af446b842d53a794b805afd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9702870b084a346adb3339c00451b97add79c72e28ea971aac5752cf03cca0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libsoup"
    depends_on "webkitgtk"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ohy", "--help"
  end
end
