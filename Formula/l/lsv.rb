class Lsv < Formula
  desc "Three Pane Terminal File Viewer"
  homepage "https://github.com/SecretDeveloper/lsv"
  url "https://static.crates.io/crates/lsv/lsv-0.1.11.crate"
  sha256 "7fef93920b47348fb35e4b27c80427cb87351fa4e09a77c2e9d7e8f9d03d274d"
  license "MIT"
  head "https://github.com/SecretDeveloper/lsv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0dc1e530f98c56c14c4e9673732ff06e62983db5f23b383ec6a34cf862adc05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3136f0b930dae2d54fa912c70397453e62572f01aa12c0bf373c4256d70f845c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f5eeb9a7f2ac1d7dbd482c116e357df8bf9871107ffbb4683d78cd9da9faa87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c44500bb20069f8a1c0d23cd0f9c7a90413b09234605589c99ae23af41739a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "059333008546452e9f46c0869f6f8121adfe237c2276a72d04e5d2881ba32aba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsv --version")

    output = pipe_output("#{bin}/lsv --init-config", "y\n", 0)
    assert_match "This will create lsv config at: #{testpath}/.config/lsv", output
    assert_match "About config.context passed to actions", (testpath/".config/lsv/init.lua").read
  end
end
