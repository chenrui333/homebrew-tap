class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.0.4.tar.gz"
  sha256 "f063f7fb62664bd0aea7851082a816b47fe11a605cad5505253766dd27e3c1e0"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39393d17e84d4fb38701bd6d65a224c7f7294a1c72d446b33a71c62378e459ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35d577457120656f19088a033d3305fea986bbb1f6c7bb687411b446f403cf02"
    sha256 cellar: :any_skip_relocation, ventura:       "5ff01c5d1c5426532e393387680334a216b264ab6fd71e2f0eaf2d131e5c10aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8691c9d544b1966eaaeca2d3ada34cb268077fc08d7a857d13add17deb995e98"
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
