class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.11.4.tar.gz"
  sha256 "527141229af75a4310cee076f08a9a22d837fc0091c4a48860b5c6a349e42f63"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be1e5ece9dedae55248ad7938ddf9853ebe01afee9481706cc2c147c067ac9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c3927d359088a0fb36af8c662afd01240dd4c98bd98d3b46d83e74d7cd5733a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6516f2234e1e56cf12cd93644bd2c932e20d40599566b6c5ac566e87f84c359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1af862d4fd29888080f874fd1b1eeccc383cac76b34fe4aef248fe37da1b03c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbecf65933d65decba1cbe18926ddd95197d21b724230f9652a485efd0f0c79a"
  end

  depends_on "rust" => :build

  def install
    cd "packages/actionbook-rs" do
      # Keep binary `--version` aligned with the tagged CLI release.
      inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
      system "cargo", "install", "--bin", "actionbook", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = shell_output("HOME=#{testpath} #{bin}/actionbook profile list --json")
    assert_match "\"name\": \"actionbook\"", output
  end
end
