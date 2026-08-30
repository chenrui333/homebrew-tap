class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.71.tar.gz"
  sha256 "cfb5cc118e6a897766aa517ee625913e848fe91ef65156326e49992d41e74718"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cbefcc1f3939edad4427bb47edf9cf0f4d71f9f8408af46517ee7dd36846af0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14f873baf53f6d1e926088beeeec896c91e3ce6dd99b3a0b925896a6a0f461b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b2c36cb159930d41a43963e440142744f79c436255aa325ed11292452dbf2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac9f563c619206645ca541027b130ad7dcec33f9c12e5a0b232fd781993828f1"
    sha256 cellar: :any,                 x86_64_linux:  "9cba6cbdf0c5924327a8c83465f9f339f75106d04d57966a7e60a20a54de34d8"
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
