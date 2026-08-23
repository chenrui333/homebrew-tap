class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.44.tar.gz"
  sha256 "6e996049beb0abb400483e36eb18460d4e4ed69456c78550d5a336913dd4f254"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9081bc3585c0a810a1c54e6a75c5f2a724ef6f943c4e8ede164aa715104c27f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "891e3262e61b7b5d79aaadebcb190c5547485bddab02a50a286814f7e1fb2c02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "103ce74d49f74dcfd0ca06d2af4adea69c691c675c82fb4648ea9dfbe166609d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a16f6eea1cdfbe4df716b2f248bf053ad8bff29dd6ddcb46a8d6f061ab41766"
    sha256 cellar: :any,                 x86_64_linux:  "8ace2f044ff13fe2732e2d276047428ccb559276108414db41425f985de3d1f7"
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
