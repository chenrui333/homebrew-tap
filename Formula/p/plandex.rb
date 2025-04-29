class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.1.0.tar.gz"
  sha256 "8ab1cbd53ca1adc3fd6999a820bd81e51f19f0c832b37b8cc7215138c55d3c3d"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "248415c1c3fe52fd5575a787e60f689c1124b2357e2bc3f4094679ee493f4790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68b7dd6081c77aa096ffa6bfe42dec350ef946f5b738c1f396d9d9383a59107e"
    sha256 cellar: :any_skip_relocation, ventura:       "f635ee31931df96ce8fb08114492f864d45d9a8ff394b6269cc9a4e77c9c43a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3900bf69d56c1838a058570394fb3fd437b8e6bff64da68da7d1c9b37f9648aa"
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
