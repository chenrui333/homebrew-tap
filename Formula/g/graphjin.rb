class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.11.3.tar.gz"
  sha256 "70e79060bec8a3074501bad60d2c25a11afdb8cb923103812c1dfc1309bbf860"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbc610d33b376e77300e4b42218946c3743f9ac808697f3b5ec9afe36548ef08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f1143f31eeead7afb477cd06367dc04368805e777722395ff383267b5678d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e0bd012b720bafdc4ba4d4ff892ee765d2b73c390672638362db9326d1653c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ff2970dcc9449a2d4c1eed0574f9fc09d424539f981a7ab57a6cf8e56d4211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee0fb2a6091cbb423c15d1b2394ba2ad73d56a7a2dc138c0804b20023464f99"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
