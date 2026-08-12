class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.14.tar.gz"
  sha256 "304673442395af8d0db2c8da6046ac89e981c0dbe0b8ba4acb18523cd2284394"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d71c958a2a29f3eb501cd6416070d297394f4dc85d4adfff3ef6cd75210093d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd35f114fa2d7c543813e409deafd8bf5860714d0c718a3ba49dc8868908fc67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e19d4a12ffbc4a29af5e2ffbbb973fad92b669e1c4652c7496771964fdbc4ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463b1b99a4ecb5f50644084768ff802495c31b1611d5a24bc8472e56b49750fe"
    sha256 cellar: :any,                 x86_64_linux:  "0d9f414d7f0f89ab39cc6f9e4773ff86a314dffcbcae3220ad22171eeefba0c6"
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
