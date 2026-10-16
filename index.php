<!DOCTYPE html>
<html lang="fr">
<head>
  <link rel="icon" type="image/png" href="images/icon.png">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  

  <title>Romé Ludovic - CV</title>

  <!-- Google Fonts -->
   <link href='https://fonts.googleapis.com/css?family=ADLaM Display' rel='stylesheet'>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link
    href="https://fonts.googleapis.com/css2?family=PT+Sans:wght@400;700&display=swap"
    rel="stylesheet"
  >

  <!-- Font Awesome -->
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
  >

  <!-- CSS -->
  <link rel="stylesheet" href="style.css">
</head>

<body>

  <main class="wrapper">

    <!-- ==================== UPPER PART ==================== -->
    <aside class="intro">

      <!-- Profile -->
      <div class="profile">
        <div class="photo">
          <img
            src="images/profil.png"
            alt="Photo de profil de Romé Ludovic"
          >
        </div>

        <div class="bio">
          <h1 class="name">Romé Ludovic</h1>
          <p class="profession">Étudiant en BTS SIO au Lycée Fulbert, j'étudie C#, SQL, et Python</p>
        </div>
      </div>
    
      <!-- Contact -->
      <section class="intro-section contact">
        <h2 class="title">Me contacter</h2>

        <div class="info-section">
          <i class="fa fa-phone"></i>
          <span><a href="tel: +33612152402">06 12 15 24 02</a></span>
        </div>

        <div class="info-section">
          <i class="fas fa-map-marker-alt"></i>
          <span>Mainvilliers, France</span>
        </div>

        <div class="info-section">
          <i class="fas fa-paper-plane"></i>
          <span><a href="mailto:marie.vicco@gmail.com">marie.vicco@gmail.com</a></span>
      </section>

      <!-- Reseau -->
      <section class="intro-section Reseau">
        <h2 class="title">Réseaux</h2>

        <div class="info-section link">
          <i class="fab fa-github"></i>

          <a
            target="_blank"
            rel="noopener noreferrer"
            href="https://github.com/Heckatt"
          >
            <span>Heckat</span>
          </a>
        </div>

        <div class="info-section link">
          <i class="fab fa-linkedin"></i>
          <a
            target="_blank"
            rel="noopener noreferrer"
            href="https://www.linkedin.com/in/ludovic-rom%C3%A9-0361a0436/"
          >
            <span>Ludovic Romé</span>
          </a>
        </div>
      </section>

    </aside>
    <div class="nav">
    <nav>
      <a class="button" href="index.php?page=education">Éducation</a>
      <a class="button" href="index.php?page=competences">Compétences</a>
      <a class="button" href="index.php?page=projets-personnels">Projets Personnels</a>
    </nav>
    </div>

    <section class="detail">
<?php
    if ($_GET["page"] == "competences") 
    {echo '
      <!-- ==================== PROGRAMMING SKILLS ==================== -->
      <section class="detail-section pg-skill">

        <div class="detail-title">
          <div class="title-icon">
            <i class="fas fa-laptop-code"></i>
          </div>

          <span>Compétences informatiques</span>
        </div>

        <div class="detail-content">

          <ul class="pg-list">


            <li>
              <span>Language Web<br>(HTML/CSS/PHP)</br></span>

              <div class="sb-skeleton">
                <div
                  class="skillbar"
                  style="--pgbar-length: 45%"
                ></div>
              </div>

              <span class="skill-percent">45%</span>
            </li>

            <li>
              <span>JavaScript</span>

              <div class="sb-skeleton">
                <div
                  class="skillbar"
                  style="--pgbar-length: 45%"
                ></div>
              </div>

              <span class="skill-percent">45%</span>
            </li>

            <li>
              <span>C#</span>

              <div class="sb-skeleton">
                <div
                  class="skillbar"
                  style="--pgbar-length: 50%"
                ></div>
              </div>

              <span class="skill-percent">50%</span>
            </li>
            
            <li>
              <span>HaxeFlixel</span>

              <div class="sb-skeleton">
                <div
                  class="skillbar"
                  style="--pgbar-length: 75%"
                ></div>
              </div>

              <span class="skill-percent">75%</span>
            </li>
            

          </ul>

        </div>
      </section>

      <!-- ==================== LANGUAGE SKILLS ==================== -->
      <section class="detail-section pg-skill">

        <div class="detail-title">
          <div class="title-icon">
            <i class="fas fa-language"></i>
          </div>

          <span>Compétences linguistiques</span>
        </div>

        <div class="detail-content">

          <ul class="pg-list">

            <li>
              <span>Français</span>

              <div class="sb-skeleton">
                <div
                  class="skillbar"
                  style="--pgbar-length: 100%"
                ></div>
              </div>

              <span class="lang-level">C2</span>
            </li>

            <li>
              <span>Anglais</span>

              <div class="sb-skeleton">
                <div
                  class="skillbar"
                  style="--pgbar-length: 83%"
                ></div>
              </div>

              <span class="lang-level">C1</span>
            </li>

            <li>
              <span>Espagnol</span>

              <div class="sb-skeleton">
                <div
                  class="skillbar"
                  style="--pgbar-length: 50%"
                ></div>
              </div>

              <span class="lang-level">B1</span>
            </li>

          </ul>

        </div>
      </section>';
    }


    else if ($_GET["page"] == "projets-personnels") 
    {echo '
      <!-- ==================== PERSONNAL PROJECTS ==================== -->
      <section class="detail-section pg-skill">

        <div class="detail-title">
          <div class="title-icon">
            <i class="fas fa-diagram-project"></i>
          </div>

          <span>Projets Personnels</span>
        </div>

        <div class="detail-content">

          <!-- ===== PROJET 1 ===== -->
          <article class="projet">

            <div class="projet-texte">
              <h3>Menu principal - Doubtful Regret</h3>
              <p>Menu principal d\'une modification d\'un jeu se nommant Friday Night Funkin\' en HaxeFlixel, avec sélection de fichiers, navigation au clavier et lancement des chansons respectives.</p>
            </div>

            <div class="projet-demo">
              <pre class="projet-code"><code>' . htmlspecialchars(file_get_contents("codes-projets/menu-principal.hx")) . '</code></pre>

              <div class="projet-fleche">
                <i class="fas fa-arrow-right"></i>
              </div>

              <div class="projet-image">
                <img src="images/Code1resultat.png" alt="Résultat du projet 1">
              </div>
            </div>

          </article>

          <!-- ===== PROJET 2 ===== -->
          <article class="projet">

            <div class="projet-texte">
              <h3>Menu Modifiers - Cool Pokémon Mod</h3>
              <p>Menu pour modifier ce qui se passe dans le gameplay sur une modification d\'un jeu se nommant Friday Night Funkin\' en HaxeFlixel, permettant de personnaliser les éléments du jeu pour rendre l\'expérience plus simple ou plus dur.</p>
            </div>

            <div class="projet-demo">
              <pre class="projet-code"><code>' . htmlspecialchars(file_get_contents("codes-projets/ModifiersSubState.hx")) . '</code></pre>

              <div class="projet-fleche">
                <i class="fas fa-arrow-right"></i>
              </div>

              <div class="projet-image">
                <img src="images/Code2resultat.png" alt="Résultat du projet 2">
              </div>
            </div>

          </article>

        </div>
      </section>';
    }
    else
    {echo '
      <!--//==================== EDUCATION ==================== -->
      <section class="detail-section edu">

        <div class="detail-title">
          <div class="title-icon">
            <i class="fas fa-user-graduate"></i>
          </div>

          <span>Education</span>
        </div>

          <div class="timeline-block">
            <h3>Lycée Jehan de Beauce</h3>
            <p>General Mathématique, Physique-Chimie</p>
            <time>2022 - 2026</time>
          </div>

          <div class="timeline-block">
            <h3>Lycée Fulbert</h3>
            <p>BTS SIO</p>
            <time>2026 - Présent</time>
          </div>

        </div>
      </section>';
    }
    
      ?>
    </section>
  </main>
</body>
</html>
