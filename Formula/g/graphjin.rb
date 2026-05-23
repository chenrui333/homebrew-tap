class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.25.tar.gz"
  sha256 "0843c5606dc546a0950ee62bd02b94708044af0f28710179ba595793efe2335d"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2797cf9e8444496d2b666d4e58bcf627063accbef23a22f18796552d40d31f28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca46440bffb78d2a5635dbe2be5b12e27e628d7d9becc45b8f72285546d914f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "362963f7f9662678c87edec42193bc9875615ce84df643713834eaabb3e0f821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189fd5513f60da8da0a718705c54c20af1d3765d810d8ba5556aa1102f691e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822a80b965f3c6e1256f7c65f4f8dcaade1e87e9c0edff0b67de965646c212a6"
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
