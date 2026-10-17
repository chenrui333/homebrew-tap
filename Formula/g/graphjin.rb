class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.14.tar.gz"
  sha256 "4f930a3145ea44d93c5a6627a878f06744b301fe4ee796d64c497a4573edb3f8"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e62f6ef1b431d8227a548a50fafa37f005b80ccf0a5b83119855a2a31dc74aed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7a5d7f06f9d0f172f488f06ffb171cd44e33223dac1c7aa4eb7133ac720e8ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59ee5f0ba6455ba8d0578e812e096bca004f0befc9e5c846109ae012a94f0a6f"
    sha256 cellar: :any,                 x86_64_linux:  "c3160ab5b5048c9f3a3e7ff2487e9b434b1cce44f3a0c08e3ef05970c361f1c2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

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
