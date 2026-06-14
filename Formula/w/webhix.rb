class Webhix < Formula
  desc "Self-hosted webhook inspector with single binary and SQLite"
  homepage "https://github.com/GaIsBax/Webhix"
  url "https://github.com/GaIsBax/Webhix/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f54e48d03b2ee783b5659766f3b069aad432afa1faa6370a62b13d0ae3299bcc"
  license "AGPL-3.0-only"
  head "https://github.com/GaIsBax/Webhix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cfd9371d4c316d6e50582c9573918c55e85a61502738157e0c6b68e6cdaecf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f46128b9012b7a92e80915ad91c0d958d0ee0051645243d9366dbfd8e017ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e0fee0157d326c52b8e56abe5b6804b703c8be78372ac7e113156ebdee3477b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd3b1f15a8efe11e13540ce2c36f8cc00b331062c3d08ca5feaba55fbbc8155b"
    sha256 cellar: :any,                 x86_64_linux:  "aa4e55ce408be3d4c29b9fafbc1868e26f2fd33e241fdca1f259c1c8cbf8205e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/webhix"
  end

  test do
    assert_match "webhix", shell_output("#{bin}/webhix --help 2>&1")
  end
end
