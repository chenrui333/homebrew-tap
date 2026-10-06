class Scope < Formula
  desc "Serial monitor with scripting support"
  homepage "https://github.com/matheuswhite/scope-rs"
  url "https://github.com/matheuswhite/scope-rs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "38b960bc5d449a8ccd869e3a6b0b5dd35088310462d1b90a19624eb4c4b4bbf2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/matheuswhite/scope-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1efea28a26b8d18cc4275ae4196299fd274f4c02a5222231a37b1926fc6c06a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9393c08aa0f106d8f0afbd02a56c6d615a176f3b7f8e9d5fb59cf63e19d349"
    sha256 cellar: :any,                 arm64_linux:   "b569f9a748e3cce64ff763ff17bc7bda5ea9773222672876d22290f9338467a8"
    sha256 cellar: :any,                 x86_64_linux:  "f26ae75e1d561a327a8ad1b018783dfdb1cf78cda383f396cfe067e644e139dd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "systemd"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"scope", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scope --version")
    output = shell_output("#{bin}/scope --name '' list 2>&1", 1)
    assert_match "session name cannot be empty", output
  end
end
