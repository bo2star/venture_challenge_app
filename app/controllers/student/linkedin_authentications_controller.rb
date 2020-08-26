# Handles login/signup with LinkedIn
#
class Student::LinkedinAuthenticationsController < StudentController

  # Handles logins and joins through linkedin.
  #
  # The session[:competition_token] will be set if we are joining a competition.
  #
  def create
    auth = Linkedin::Authentication.new(env['omniauth.auth'])

    if session[:competition_token]
      competition = find_competition(session[:competition_token])

      # Clear the competition_token session variable so that later logins
      # don't look like you're trying to join that competition.
      session[:competition_token] = nil

      join_competition(competition, auth)

    else
      login(auth)
    end
  end

  # Something went wrong during linkedin authentication. Most likely the user canceled
  # the login.
  def failure
    redirect_to login_path, notice: "Sorry, something went wrong. Please try logging in again."
  end

  private

    # Join a competition
    #
    # Exception:
    # The user may already be using the system because a) they've joined a different competition,
    # or b) they've already joined this competition and are following the join link again.
    # In either case, we bring them to their dashboard for the competition they already joined.
    #
    def join_competition(competition, auth)
      if existing_student = Student.find_by(linkedin_uid: auth.uid)

        login_as(existing_student)

        if competition != existing_student.competition
          flash[:notice] = "You've already joined a different competition. Here is your dashboard for <strong>#{existing_student.competition.name}</strong>."
        end

        redirect_to team_path

      else
        student = Student.create!( competition: competition,
                                   name: auth.name,
                                   email: auth.email,
                                   avatar_url: auth.image,
                                   linkedin_uid: auth.uid,
                                   linkedin_token: auth.token )
        login_as(student)
        redirect_to new_team_membership_path
      end
    end

    # Log in
    #
    # Exception:
    # A new user may be trying to log in. In this case we can't know what competition they want to join,
    # so we redirect them to the login path and give them a message telling them what to do.
    #
    def login(auth)
      if student = Student.find_by(linkedin_uid: auth.uid)
        login_as(student)
        redirect_to team_path
      else
        redirect_to login_path, notice: "You haven't joined a competition yet. Please follow the link your professor gave you to join."
      end
    end

    def find_competition(token)
      Competition.find_by!(token: token)
    end

end