class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.34.tar.gz"
  sha256 "419b6fcd835eeddeffa16cde809ab1743906b4e852124b1a91d00cff07302f47"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07cea2de0aad400fd80887f50e72b0f6d8379ac44530336f534a301607c1a5ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b7524c793606cd1a7262ee6048ad92a9e7e7b17bd113928900ef731ae10283a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9191166a546bad6cb4e5e70476c49efaa66de36170f59222c25fb2f54c9ebaca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f3a63b9b3e409d81249a19781247fa7cf9f187171e3fb5f50f2e00b10eef4ca"
    sha256 cellar: :any,                 x86_64_linux:  "fab683b7e3cf95476e2260d5e81c1dc33a2f40a27aaab84692b1e38bf5e8070d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
