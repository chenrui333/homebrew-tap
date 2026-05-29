class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.29.tar.gz"
  sha256 "98afb6f31ade64064c9c0650dec79f0d13f9ddc2dbee44c85554c76f84b36b5c"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d940582b6d8127261bb8f0c0060ce79d71cfb0d5016b25586c15c5f6c1328688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53c2c3cb226a2450d71e4178ed9d6ff46803d230a353a2a276c32c698ecfe4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "930b955f72b857b61f1a19c8f67cc391bce9f618461a5dbe04b27ffc93c278c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "088a81926a0ba13ab0ff5178c3e5b8e1885892c6f66ab44779f478d4068b0c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93c41033c7dac6a96235c46e12ad06ffdec2b86bca76d5e15bb83ba3cc874d8"
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
