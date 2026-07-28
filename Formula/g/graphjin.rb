class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.2.tar.gz"
  sha256 "3a4e78d0955a526bb31485c140b17fffbdf450480801cfce5aac080cd48955f4"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7adc5ea019c87cebd91124f07de9c26885d98e2d4ca4f86bc2459fa64c29fe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ace0e44669a5482b3ad62e5bb8d65e7aafc2d36580fe19247307aa3a34e8a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7720d90aeec655ad199cbce8157b972f52ee101b2888aa0a045c44ddeb79a6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edda4eafb41e5f07b222618bbbf6bf42ecdfa0d9381c672431378b4b2d18003e"
    sha256 cellar: :any,                 x86_64_linux:  "d779ea30ab5591af1b20b90c1a833486ab3c2f8daff430c308effb612a6c529f"
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
