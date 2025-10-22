class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c26740f818b665ce965d383d8007f029ae5545d4a7bcb733ba9a657ceb033815"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "565d30adec6162563e3adebb9bd64980b475612d243476d0fd5b03e89e3b20ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c08117f2e3aca3b78c2ce7b7e5c1fcb5cbb3778f7ca0368bcc8b2974c5b375d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f56527c2ac13c4407ccb5884e616ac972a5a67d628f673862b37f1273adafb8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9260d6161ce2fdfc05e1ca949f3d0c5a163ef2fe51dcab051115fa6cf83fd5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14b4bea8dc90b1f769d9af350211766c1a7855e16e8ee8468d374045a27abb55"
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
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
