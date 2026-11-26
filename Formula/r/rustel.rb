class Rustel < Formula
  desc "Terminal live coding studio for the Strudel music pattern language"
  homepage "https://github.com/tzfm/rustel"
  url "https://github.com/tzfm/rustel/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "ca2143f28bb45b2fc80ebdde8cd622a08b8d3f6a33a033a75bddeb51efc28f57"
  license "AGPL-3.0-or-later"
  head "https://github.com/tzfm/rustel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "23bd940627cc1e56f45a35f75c3ed4e301b0c7e37e6fc882203f158dd7c641d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a435b1ba48976f563190ce518fcfd8b1cbc0df0449335f2e687e991f0699458c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eebe7be860e1c27be53679ae4ecb22a7da9cc62cdbd9e269c78c77b3963c9cad"
    sha256 cellar: :any,                 arm64_linux:   "c1b69a64f240d4ca010be2372b2fb29cfb38fcf97c28848c37e077bec4ae36bb"
    sha256 cellar: :any,                 x86_64_linux:  "243429b9f590026b57df53e78630bdcd2587716560c28ecab9ddfea564ef0ebc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  on_intel do
    depends_on "nasm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"rustel", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustel --version")

    output = shell_output("#{bin}/rustel query -e 'note(\"c e\")' --end 1/1 --json")
    assert_equal %w[c e], JSON.parse(output).fetch("haps").map { |hap| hap.fetch("value").fetch("note") }
  end
end
