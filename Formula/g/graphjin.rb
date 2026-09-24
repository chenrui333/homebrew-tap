class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.78.tar.gz"
  sha256 "80c4e5ed47dd9233cadf4b0a44c4081f51ffbe4e0d3b9b905a1a5fe03c7fab8d"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fe641b15d748d357947923cb04de714d8767990a7ed33c1ae731d8fb7b735fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29dc0210fac80e0151d19052db2d98401bcbb8ce7121ef47fe76f2f3155623d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b2599cfd3f3484775bcffb9d3a1357dc9c8b562d388706247f02032bc3ee99f"
    sha256 cellar: :any,                 x86_64_linux:  "2e2d360cea0d62ecd768b3db08d16bec83b06a66d41bed0942809aaef1882258"
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
