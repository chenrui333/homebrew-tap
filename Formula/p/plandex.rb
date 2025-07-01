class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.2.0.tar.gz"
  sha256 "fb3d8beef5e191240b88206a77213c09b0c276d21f845ad5e1c7aa06857ca357"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5130cfdef30343d040efc4ede5cd6ebd3c6585ecd95262f5ca702ad254234e3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0aa7c7538830d8e770a8b084c876f60f485a44b6f9fbccfc1072caab6f203f3"
    sha256 cellar: :any_skip_relocation, ventura:       "0046118fc52ee099768dd73d233dc7fa4d286ab18381fdab0b7e3a10d49f8002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c08f6d8537515b7520137bbab8814195c30709b5d5538086378fe3d74239ae84"
  end

  depends_on "go" => :build

  def install
    cd "app/cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X plandex-cli/version.Version=#{version}")
      generate_completions_from_executable(bin/"plandex", "completion")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plandex version")

    # now it has annoying
    # # ? 👋 Hey there!
    # # It looks like this is your first time using Plandex on this computer.
    # # What would you like to do?
    # # > Start a trial on Plandex Cloud
    # #   Sign in, accept an invite, or create an account
    # system bin/"plandex"
  end
end
