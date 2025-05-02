class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.1.1.tar.gz"
  sha256 "53d2f9007c32872a116a2344661951b46b04febd1ff6eedd5aac8e1761f6591d"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63e0bcafc86160e766189365260b7858d5b84879743dae49d883999e6a1d08a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6309b50666b255f555437c474b1065bd92b18b5690378de79f1f65b61b74a1"
    sha256 cellar: :any_skip_relocation, ventura:       "e93a812bd81583c9dbf2c9afcb2beda620e11a132d31e6ff931c5eae30210eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095e98eb095a81fb962cbf5dd57de7810aba2e96339cf5b8df0c022ac8a6cfd2"
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
