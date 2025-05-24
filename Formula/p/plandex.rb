class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.1.5.tar.gz"
  sha256 "7f6be0d7798eaaab888683fc377c9a9a4f4ce4b1161dd49ae44a9cf7483f4562"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b44ca5c7b8c4573a5d231f367e1fb9707266e909d397d4292e4dc0a9021c8eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9feac529ea16d31712d4945eaf23346ff0ba1e3bf9dae7aea9b007fd96ffd393"
    sha256 cellar: :any_skip_relocation, ventura:       "22b2448848355f7101e33de3009b1ba797668dc5103874fa53a495348adb466a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d33a180d2a9c5d58b5be0f127257ebf60db9a233f007cc391c8fe5623a7699d"
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
