class Sigye < Formula
  desc "Feature-rich terminal clock with ASCII art fonts"
  homepage "https://github.com/am2rican5/sigye"
  url "https://github.com/am2rican5/sigye/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c738fdf8cf717d296b5f34296a761daf144ec799267931b1a217be2fc1a10d8d"
  license "MIT"
  head "https://github.com/am2rican5/sigye.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5b34059e18178296c0a9b37b584b6c05891f1c2887b935f868c5c43dabd5c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e7f6262601d5285163dcd25534a8648bb4d0a6faf3d54280f6b6459b7ac18f"
    sha256 cellar: :any,                 arm64_linux:   "a5c4237d0fc6bd17a8f4de9b9fc4a3b4af318eef35dfc1b83bc38f914b4f33e1"
    sha256 cellar: :any,                 x86_64_linux:  "3c6f00b762827793c09d0b8e331ec5ea3d4093cb9c6c5f8fec3bee20beb2b4cb"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--manifest-path", buildpath/"Cargo.toml"
  end

  def install
    ENV["CARGO_NET_OFFLINE"] = "true"
    system "cargo", "install", *std_cargo_args(path: "crates/sigye")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigye --version")
    output = shell_output("#{bin}/sigye --once --format unix")
    assert_match(/\A\d+\n\z/, output)
  end
end
