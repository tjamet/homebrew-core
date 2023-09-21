class Maiao < Formula
  desc "Seamless GitHub PR management from the command-line"
  homepage "https://github.com/adevinta/maiao"
  url "https://github.com/adevinta/maiao.git",
    tag:      "1.1.0",
    revision: "a105d869324d20a9c94081cb0f03149a743e184b"
  license "MIT"
  head "https://github.com/adevinta/maiao.git", branch: "main"

  depends_on "go" => :build
  conflicts_with "git-review", because: "maiao provides an implementation of git-review for github"

  def install
    ldflags = %W[
      -s -w
      -X github.com/adevinta/maiao/pkg/version.Version=#{version}+homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"git-review"), "./cmd/maiao"
    generate_completions_from_executable(bin/"git-review", "completion")
  end

  test do
    assert_match "#{version}+homebrew", shell_output("#{bin}/git-review version")
    system "git", "init"
    system "#{bin}/git-review", "install"
    assert_predicate testpath/".git/hooks/commit-msg", :exist?
  end
end
