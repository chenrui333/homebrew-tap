# framework: clap
class Huber < Formula
  desc "Simplify GitHub package management"
  homepage "https://innobead.github.io/huber/"
  url "https://github.com/innobead/huber/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "7648c2840c2747fce2079e19cd57702b573bc03e200400f53125a47f37c4b817"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d7b9ed368c6f508c865f4bef32fe9cff9a439e601bd003bfbf97112711247eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d875976273831c33f0a55f10e71a1336ada738c77384da5e6df140ec3e88ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b8e2a02d6d3e1c00d92e2c0101149e7c1b1b5de44dca6d76b245459911af526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e81ff186d79f193423604b579fc4850370e11a93657a13abf8e1d1efcb293a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b46cd3d6e10a446f1634246d1c7adb79f437bd9889aba2b9ad99983815635414"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "huber")
  end

  test do
    require "utils/linkage"

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"huber", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
